

## 个人认知

- 在稍微大一点点的公司中，有两个基础系统是必然有的：一个是：SSO（单点登录系统），一个是 UPMS（通用用户权限管理系统）
- 而这两个系统都是很难完全地直接套用开源框架。因为，在这类规模公司中，基本已经有成气候的系统、用户，这部分用户体系，不可能说换就换。一般是要反过来设置：让新系统去适应现有的账号系统、权限管理体系。
- 目前单点登录技术选型中，用得比较多的有：CAS、Keycloak、Spring Security OAuth2
- 其中 Keycloak 除了认证还带各种授权玩法，整个体系的规划挺好的，适合业务的一开始阶段。如果是成规模之后再考虑要使用它，改造成本很大。
- CAS 什么都好，支持了各种扩展接口，几百个可扩展的子模块。但是，这么大的项目现在就一个人维护，他既要开发又要写文档、写测试，实在是难为他了。记忆深刻 2017 年他嫌提问的人太 low、太麻烦，直接把 issues 关了，至今未开。而且这家伙非常喜欢用新版本，JDK、Spring Boot 动不动就升级。现在想起研究它的那段时间，简直了...Orz
- Spring Security OAuth2 是 Spring Cloud 流行之后大家非常喜欢用的一个系统。目前来说真的没啥缺点，不管是可读性、可维护性、可变更性等方面上，大家都很喜欢。但是，不够灵活，业务上的灵活，特别是国内各种非工程化思维下的各种特殊要求。我不觉得老板们这些需求不合理，但是基于这些开源系统真的好难。
- 所以，我写了 TKey，目标很明确：需求总是各种各样，我没办法帮大家做好扩展，那我就帮大家写好文档。你们自己知道怎么用，自己爱怎么改就怎么改。


## OAuth 核心（比较绕）

- TKey 的接口是按照 OAuth 2.0 规范来，所以必须了解这个。
- OAuth 2.0 是规范、是安全标准，不是框架。它的核心逻辑是：颁发 Token，使用 Token
- OAuth 2.0 规范定义了授权协议，不是身份认证协议
- OAuth 2.0 广泛用于各大开放平台，比如大家常接触的 QQ、微信等平台
- 认证系统可以支持很多协议，比如 SAML、LDAP 等，OAuth 2.0 可以只是其中的一种。
- 单单的 OAuth 2.0 协议是做不了一个认证系统
    - OpenID Connect 开放协议是建立在 OAuth 2.0 之上的，它就可以作为认证协议
    - 除了 OpenID Connect，基于 OAuth 2.0 构建的协议还有很多，UMA、HEART、iGov 等
- TKey 作为认证系统的认证核心是：
    - 用户持有的 TGC 令牌（ID 令牌），它才是代表着用户信息，代表着认证系统的登录证明。用户与登录系统之间是用 TGC 来连接。TGC 生成方法：`oauthGenerateService.generateTgc();`
    - OAuth 所颁发的 Token 是让客户端系统（业务系统）与认证系统之间进行连接
    - TKey 基于 OAuth 2.0 进行设计的的最大好处在于它是通用标准，在让别人来对接我们登录系统的时候只要按照标准即可
    - 所以，可以把接入 TKey 过程理解成接入 QQ 开放平台、微信开放平台过程
- 授权码模式时序图

![授权码模式时序图](http://img.gitnavi.com/tkey/tkey-oauth.png)


-------------------------------------------------------------------


## 常见登录系统

- 最优秀登录系统：Google Accounts
    - 在 Google 那么多产品中，登录这件事是那么的经典而自然，永远的地方都是：<https://accounts.google.com>
- 较一般的：腾讯、阿里等
    - 阿里的淘宝和天猫是同一个用户体系，阿里云是另外一个体系。
    - 腾讯的 QQ 和微信各自独立
    - 百度普通用户和百度智能云用户也是两个用户体系
- 类似 Okta 这类新玩法，当前国内 saas 丰富度还不够，暂时比较艰难

## 登录系统的几种场景

- **最核心的点：** 对于业务系统来讲，有没有前置的 API 网关影响一生
- **API 网关作用：** 路由、过滤、身份验证、鉴权、限流、熔断、重试、监控、负载、版本/灰度发布、缓存等等
- API 网关是所有请求的第一道入口，如果你们公司刚好再做整体系统架构调整，要引入单点登录系统之前，我建议一同连同 API 网关一起调研了

## 开放平台的登录系统

- 类似 QQ 第三方登录过程
    - 你需要找 QQ 开放平台先申请 AppId + AppKey
    - 也有人叫做：AppKey + AppSecret; ClientId + ClientSecret
    - OAuth 2.0 规范的标准叫法是：ClientId + ClientSecret，[具体点击查看](https://tools.ietf.org/html/rfc6749#section-11.2.2)
- 采用授权码模式拿到 QQ 平台给你的 AccessToken
- 这个 AccessToken 你只能获取到用户基本信息
- 在你调用 QQ 平台的所有接口过程中，必须带上该 AccessToken，不然它不知道是谁在调用
- 你只能跟 QQ 开放平台打交道，你不能拿着这个 AccessToken 去调用微信开放平台


## 有 API 网关的同构业务系统

- 比如 Spring 的 Spring Cloud 体系
- 对身份进行认证全部交给 Gateway、Zuul，内部的业务系统只要管理好自己的 API 服务即可
- 在 Spring Cloud 体系中，内部的服务都是在内网中，都是设定彼此之间是安全的


## 有 API 网关的异构业务系统

- 有的公司有好几个研发中心、研发部门，各自采用各自的业务系统架构（历史原因）
- 引入 Kong、Tyk、OpenResty + Lua 等 API 网关之后，各个业务系统在网关后面，身份验证也是交给网关


## 无 API 网关的同构 / 异构系统

- **这种场景在中型公司转型过程中基本都要遇到，我个人建议是 API 网关和单点登录一起抓**
- 这里说下在有单点登录系统情况下，但没有 API 网关的跨系统调用
    - 业务系统 A 在单点登录系统登录成功后拿到属于自己的 Token-A
    - 当同一个浏览器访问业务系统 B 的时候，B 系统也是需要登录的，但是因为单点登录系统已经知道当前浏览器是谁在用，所以直接给业务系统 B 颁发了 Token-B。这个过程用户无需重新登录，也就单点登录了
    - 业务系统 A 自己维 Session-A 与 Token-A 之间的关系
    - 业务系统 B 自己维 Session-B 与 Token-B 之间的关系
    - 这时候业务系统 A 要调用业务系统 B，必须拿着 Token-A 去找业务系统 B
    - 业务系统 B 拿到请求中的 Token-A 会找单点系统询问该 Token-A 是否有效，以及 Token-A 对应用户信息是谁
    - 业务系统 B 知道当前请求是谁之后就会放开请求
- 这个过程是一个瓶颈
    - 如果业务系统 B 自己不存储这些 Token-A，则每次都要询问单点登录系统，单点登录系统压力会很大
    - 如果业务系统 B 自己存储这些 Token-A，则 Token-A 的时效性就有偏差


## OAuth 2.0 与 JWT

- 现在有很多人喜欢用 Spring Security OAuth + JWT 构建登录系统
- JWT 的自包含、防篡改的特点让很多人喜欢，可以省掉最让人烦的集中式的令牌，实现无状态。
- 可是，这是有场景限制的。比如主动吊销 Token 要如何处理、有效时长如何动态控制、密钥如何动态切换。
- 如果没有主动吊销 Token 的业务需求，那自包含的特点确实很有用，只是看大家的业务场景了。



-------------------------------------------------------------------

## 其他核心术语认知（提供了查询入口）

> 架构设计 无状态

- [Google 搜索](https://www.google.com/search?q=%E6%9E%B6%E6%9E%84%E8%AE%BE%E8%AE%A1%20%E6%97%A0%E7%8A%B6%E6%80%81)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=%E6%9E%B6%E6%9E%84%E8%AE%BE%E8%AE%A1%20%E6%97%A0%E7%8A%B6%E6%80%81)

> 认证 与 授权 的区别

- [Google 搜索](https://www.google.com/search?q=%E8%AE%A4%E8%AF%81%20%E4%B8%8E%20%E6%8E%88%E6%9D%83%20%E7%9A%84%E5%8C%BA%E5%88%AB)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=%E8%AE%A4%E8%AF%81%20%E4%B8%8E%20%E6%8E%88%E6%9D%83%20%E7%9A%84%E5%8C%BA%E5%88%AB)

> HTTP 请求头：User-Agent

- [Google 搜索](https://www.google.com/search?q=HTTP%20%E8%AF%B7%E6%B1%82%E5%A4%B4%EF%BC%9AUser-Agent)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=HTTP%20%E8%AF%B7%E6%B1%82%E5%A4%B4%EF%BC%9AUser-Agent)

> HTTP 状态码：301 302 401 403

- [Google 搜索](https://www.google.com/search?q=HTTP%20%E7%8A%B6%E6%80%81%E7%A0%81%EF%BC%9A301%20302%20401%20403)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=HTTP%20%E7%8A%B6%E6%80%81%E7%A0%81%EF%BC%9A301%20302%20401%20403)

> 跨域

- [Google 搜索](https://www.google.com/search?q=%E8%B7%A8%E5%9F%9F)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=%E8%B7%A8%E5%9F%9F)

> 分布式 无状态

- [Google 搜索](https://www.google.com/search?q=%E5%88%86%E5%B8%83%E5%BC%8F%20%E6%97%A0%E7%8A%B6%E6%80%81)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=%E5%88%86%E5%B8%83%E5%BC%8F%20%E6%97%A0%E7%8A%B6%E6%80%81)

> 中间人攻击

- [Google 搜索](https://www.google.com/search?q=%E4%B8%AD%E9%97%B4%E4%BA%BA%E6%94%BB%E5%87%BB)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=%E4%B8%AD%E9%97%B4%E4%BA%BA%E6%94%BB%E5%87%BB)

> 重放攻击

- [Google 搜索](https://www.google.com/search?q=%E9%87%8D%E6%94%BE%E6%94%BB%E5%87%BB)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=%E9%87%8D%E6%94%BE%E6%94%BB%E5%87%BB)

> Session 与 Cookie

- [Google 搜索](https://www.google.com/search?q=Session%20%E4%B8%8E%20Cookie)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=Session%20%E4%B8%8E%20Cookie)

> Tomcat JSESSIONID 作用

- [Google 搜索](https://www.google.com/search?q=Tomcat%20JSESSIONID%20%E4%BD%9C%E7%94%A8)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=Tomcat%20JSESSIONID%20%E4%BD%9C%E7%94%A8)

> Cookie HttpOnly secure

- [Google 搜索](https://www.google.com/search?q=Cookie%20HttpOnly%20secure)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=Cookie%20HttpOnly%20secure)

> LocalStorage 与 SessionStorage

- [Google 搜索](https://www.google.com/search?q=LocalStorage%20%E4%B8%8E%20SessionStorage)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=LocalStorage%20%E4%B8%8E%20SessionStorage)

> Basic Auth Bearer Token

- [Google 搜索](https://www.google.com/search?q=Basic%20Auth%20Bearer%20Token)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=Basic%20Auth%20Bearer%20Token)

> OAuth 2.0 四种授权模式

- [Google 搜索](https://www.google.com/search?q=OAuth%202.0%20%E5%9B%9B%E7%A7%8D%E6%8E%88%E6%9D%83%E6%A8%A1%E5%BC%8F)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=OAuth%202.0%20%E5%9B%9B%E7%A7%8D%E6%8E%88%E6%9D%83%E6%A8%A1%E5%BC%8F)
- 授权码模式把步骤拆开，最核心的点：保证了是客户端本身进行的身份认证。简化模式就做不到，所以不推荐简化模式。

> OAuth 2.0 state CSRF

- [Google 搜索](https://www.google.com/search?q=OAuth%202.0%20state%20CSRF)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=OAuth%202.0%20state%20CSRF)

> OAuth 2.0 redirect_uri 验证

- [Google 搜索](https://www.google.com/search?q=OAuth%202.0%20redirect_uri%20%E9%AA%8C%E8%AF%81)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=OAuth%202.0%20redirect_uri%20%E9%AA%8C%E8%AF%81)

> API 网关的作用

- [Google 搜索](https://www.google.com/search?q=API%20%E7%BD%91%E5%85%B3%E7%9A%84%E4%BD%9C%E7%94%A8)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=API%20%E7%BD%91%E5%85%B3%E7%9A%84%E4%BD%9C%E7%94%A8)

> UPMS 用户权限管理系统

- [Google 搜索](https://www.google.com/search?q=UPMS%20%E7%94%A8%E6%88%B7%E6%9D%83%E9%99%90%E7%AE%A1%E7%90%86%E7%B3%BB%E7%BB%9F)
- [Baidu 搜索](https://www.baidu.com/baidu?wd=UPMS%20%E7%94%A8%E6%88%B7%E6%9D%83%E9%99%90%E7%AE%A1%E7%90%86%E7%B3%BB%E7%BB%9F)



