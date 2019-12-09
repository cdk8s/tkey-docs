
## TKey SSO Server


- 大部分场景下的设计都是有原因，我说说我们的考虑


## 关于 Token 命名与格式

- 在命名上借鉴了 CAS，比如：AT-，RT-，OC-，TGC 这类都是来源 CAS。
- OAuth 2.0 没有规定 token 的命名，你如果不喜欢也可以自己改造下。
- 关于 Bearer 和 Authorization 这两个关键字，规范中没有明确要求要不要区分大小写。但是从业界使用情况看，我们一般都建议首字母大写。TKey 虽然在大小写上也做了兼容，但是建议大家还是首字母大写。


## 为什么用户认证是通过 REST API 而不是数据库

会 Spring Boot 的人自己加个 Mapper 之后去查数据库，这个真的不难吧。

但是我这样设计是有原因的。

有很多企业的用户体系其实起步已经很早了，可能是用 Oracle、MSSQL、LDAP 等等，如果你很幸运，刚好是 MySQL 那确实稍微改一下就可以了。

可是现实中很多企业不是，而我又不想 TKey 引入太多内容，所以我建议是那些老系统开放出 REST API，TKey 通过内网方式调用老系统验证用户信息。

## 为什么 code 只能用一次

标准虽然没有强制规定 code 能用多少次，但是从安全角度来讲，以及业界大家使用上目前都是 code 只能被使用一次。

如果你们对此有需求可以在：`OauthCodeToTokenStrategy.java` 中找到该代码进行调整：

```
codeRedisService.delete(oauthTokenParam.getCode());
```


## 为什么引入 Redis

大家如果看过 TKey 的压力测试文档内容，会知道目前主要的瓶颈开销在 Redis 连接和存取上。

可是，我是坚定要上存储介质的，可以不是 Redis，可以换成：LevelDB、SSDB、RocksDB、Memcached 等等。但是必然要有一个存储介质来存储 Token 信息。不然无法解决任意横向扩展 TKey 服务这件事。

也因为引入了 Redis，所以 TKey 的维护就变成异常简单，因为它无状态，想停就停，想启动就启动。我们只要维护好：Redis 的高可用，保持好网络通畅。

小公司自己维护 Redis 没什么问题，因为量不大。如果公司已经成规模，建议直接采用云上 Redis，尽可能保住高可用。


## OAuth 2.0 Token 请求参数的 3 种方式

按 OAuth 2.0 的标准，要使用 Token 有 3 种方式：

- 使用 HTTP Authorization 头部（优先推荐）
- 使用表单格式的请求体参数
- 使用 URL 编码的查询参数

优先推荐请求头方式或 POST 表单，因为 URL 比较容易被日志监控中拿到。

如果我部分文档或测试采用 URL 方式，那只有一个原因：为了方便。大家不要学习这种行为。

目前 3 种模式我都做了支持，但是优先推荐请求头。


## 刷新 Token 接口的返回 JSON 内容

刷新 Token 接口目前 TKey 返回内容格式是这样的：

```
{
  "access_token": "AT-101-IDm312Our5Jti70BGE8RgO2qRK29blri",
  "token_type": "Bearer",
  "expires_in": 57600
}
```

但是，业界还有一种玩法，在给了新 AccessToken 之后，重新给你一个新的 RefreshToken，我个人是觉得没必要，所以不对这种玩法进行支持。

```
{
  "access_token": "AT-IDm312Our5Jti70BGE8RgO2qRK29blri-101",
  "refresh_token": "RT-8aI3zHbArcmzT3ukHlBQ88AdMv2NB8Aa-103",
  "token_type": "Bearer",
  "expires_in": 57600
}
```

## 功能开关

- 由于目前功能相对单一，所以暂时不设置任何功能开关，后期版本迭代多了必然要上功能开关。
- 同时也建议在开发系统的时候注重这一块的设计，不然维护起来成本会大很多。

## 为什么选择 Prometheus

- InfluxDB 挺好的
- 但是，后面要上 K8S，不想扩展出多个时序库，所以就选择了 Prometheus

## Actuator 

Spring Boot 可以借用 Spring Security 来实现 Actuator 的访问认证，但是为了方便 Prometheus 拉取数据，这里并没有这样设计。所以目前 actuator 是完全裸奔的。

建议是不对外开放 IP 访问，或者在 Nginx 配置上该路径的 Basic Auth，避免信息泄露。


## TKey 的 userinfo 接口返回的用户信息为何冗余


在每个系统中，用户唯一主键叫什么名字都是不一样的，有人叫：id，userid，user_id，id_ 等等等

而用户信息根对象中必须要有一个主键，我这里借鉴了 Spring Security 的 FixedPrincipalExtractor.java 类。它限定了这几个：`user`、`username`、`userid`、`user_id`、`login`、`id`、`name`。所以我也为了做兼容冗余了部分字段。


## ApplicationTestDataInitRunner.java 的作用


为了方便测试，我会在该类有一个初始化预设几个 code 和 token 的动作，虽然已经在开头限制了：`@Profile({"dev", "gatling", "test", "junit"})`

但是，还是提醒大家上生产的时候要注意这个细节。

## 为什么没有 scope 设计

OAuth 很核心的点就是 scope，但是我在这个版本没有考虑。因为我目的很明确，就是为了做单点登录，并且初期还不是开放平台方式的那种单点登录。所以，如果加上 scope 设计，整个登录过程会过于冗余。

当然，我们也可以设计该功能，然后做上开关。只是暂时不是我们的优先级。

内部系统的授权一般建议交给 API 网关统一处理。

如果你目前就有scope 的需求，那我建议你自行先改造。按 OAuth 2.0 规范，scope 的设计是用空格隔开的，比如：`read write delete`

## 为什么没有 找回密码、修改密码功能

找回密码和修改密码是 UPMS 管的，不应该是 SSO 的事情，只是登录页面可以放个链接跳转到 UPMS 系统去而已。


## 为什么没有单点登出

单点登出分两种业务场景：

- 1. 从某个业务系统登出，其他已经登录过的业务系统不做变更，要访问的新系统则需要重新登录
- 2. 从某个业务系统登出，其他已经登录过的业务系统也跟着退出

第一种业务场景比较好理解。

第二种业务场景又可以分为两种情况：

- 1. 有 API 网关
- 2. 没有 API 网关

如果有 API 网关，在任何业务系统退出，本质就是网关上退出，那你下次访问任何业务系统肯定都是要重新登录

如果没有 API 网关，则这里就要引入 MQ 或则 RPC 通信。每个业务系统监听 TKey 的 MQ 通道，当发现各自的业务系统中有当前退出用户的 Token 则要自己进行销毁。但是这样的设计复杂度就上来了，不划算。所以，这里又一次提到了 API 网关，API 网关真的很重要。

还有一种适合小企业的办法。就是 TKey 和业务系统都用同一个 Redis，然后 TKey 再新增加维护一个新的 Key 规则：`userId ： 所有业务系统生成过的 Token 集合`。这样，当某个业务系统退出，TKey 就可以通过 userId 找到所有 Token 进行删除。但是，感觉这样的企业应该很少，都要上单点登录了，应该规模还可以，不应该同用一个 Redis...



## 为什么 TKey SSO Client Java 那么多版本

考虑到有些业务系统已经用 Spring Security 的，为了使得改造成本尽可能减小，所以这里做了 demo 实例。

其中 Spring Security 在 4 和 5 版本上本身做了的大修改，所以我这边做了两个 demo 来区分开。

- 在 Spring Boot 1.5.x 中使用的是 Spring Security 4 
- 在 Spring Boot 2.1.x 中使用的是 Spring Security 5

但是，如果觉得不管怎么改造都有成本，那我建议参考我自己写 REST Client demo，这有助于你后期各种需求下的玩法。


## 前后端分离要注意什么

前后端分离分为两种场景：

- 1. 前后端的域名只是二级目录不一致，或者三级域名不一致
- 2. 前后端的域名完全不一致

第一种情况还可以采用 Cookie、Session 的方式维护，虽然不推荐，但是确实是可以这样做的。

第二种情况 Cookie、Session 是完全用不了的，只能把 Token 信息交给前端存储在 LocalStorage、SessionStorage 中，请求的时候带上请求头。推荐大家使用这种。

但是这里有一个小细节，如果使用我们的 TKey Client，则 `enable-code-callback-to-front: true` 必须是 true。表示 code 的回调在前端接收，然后前端再交给业务后端去调用 TKey，不然整个过程，你前端与后端是没有任何交流的，也就拿不到最后业务后端的 Token。所以才有这一步的设计。但是我个人觉得不够优雅，如果大家有跟优雅的方式，赶紧联系我们~


## 密码模式的常用场景分析

- 默认是采用授权码模式，要来回跳转。虽然这样会安全一点，但是有些环境可能不需要那么安全，只要方便就行，比如小程序、APP 那我推荐使用密码模式。
- 假设场景如下
    - 这类前端一般都有自己的登录页面，用户输入账号密码后，直接请求 TKey Server，TKey 直接返回 JSON 信息给前端，前端可以存储到 Session Storage 中。
- 这时候后端就有两种场景：
    - 有带 API 网关
        - 有带 API 网关最为简单，API 网关拿到 Access Token 发现自己的 Redis 中不存在该 Token 就会去找 TKey Server 求证，如果是有效的，则存储 Token 以及相应的用户信息到自己的 Redis 中
        - 存储完成后，放行请求，后面的请求会因为网关 Redis 已经存在了该 Token，所以也就省去再去找 TKey Server 求证
    - 没带 API 网关
        - 没带 API 网关相对于有带 API 网关的差别，在于每个业务系统的 Redis 也都必须先存储后放行
        - 如果是小公司，全部公司就一个 Redis，那你就爽了，直连查询。但是这种粗暴的方式也带来隐患，如果出了生产事故，不知道算谁的责任。
- 需要小改动的地方：
    - 在 API 网关或业务系统的登录拦截器中 LoginInterceptor.java 多加一个判断：如果本业务 Redis 中没有存储该 Token，则求证 TKey Server
    - 如果 Token 有效，则存储 Token 和用户信息到本业务的 Redis 中
    - tkey-sso-client-starter-rest.jar 在 1.0.2 版本之后提供了方法：TkeyService.getUserProfile(accessToken)


## 刷新 Token 如何使用

如果你们的业务系统都是在 PC 上，那其实我觉得可以不考虑，因为 TGC 的有效期很长，特别是勾选了记住我之后，默认有 7 天的时间，在这个过程中，只要用户不清除缓存、Cookie，则每次访问业务系统都会生成新的 AccessToken。

这时候用不用 RefreshToken 都无所谓了。

但是如果你们有移动端的业务场景，那就需要考虑移动端用户通过 RefreshToken 自动帮用户刷新的 Token 进行使用。






















