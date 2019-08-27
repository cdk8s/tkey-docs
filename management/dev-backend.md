
## TKey Client Management 开发环境

- [参考 TKey SSO Server 环境]()

## TKey Client Management 项目核心组件版本

- [参考 TKey SSO Server 环境]()


## TKey Client Management Token 有效期设置


在没有 API 网关的情况下，各业务系统的 Token 是自己维护的。

Client Management 的 Token 有效时长参数是：`token-max-time-to-live-in-seconds: 86400`，也就是 24 小时

如果你设置为 30 秒，其实也没事。用户体验上会出现：用户登录操作 30 秒之后，浏览器又重定向到 TKey SSO 重新生成了新 Token，整个过程依旧还是不需要用户重新输入账号密码。因为 TGC 的有效期很长。


## H2 数据库

为了方便开发，默认 `application-dev.yml` 是 H2 数据库。

为了生产 MySQL 的需要，也带有 `application-devmysql.yml`，大家可以自行切换














