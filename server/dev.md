
## TKey 开发环境

- macOS High Sierra 10.13.6 
- Oracle JDK 1.8.0_191
- Maven 3.6.0
- IntelliJ IDEA 2019.2
- Redis 4（Docker Image）
- Prometheus 2.11（Docker Image）
- Grafana 6.2.5（Docker Image）
- MySQL 5.7（Docker Image）
- Postman 7.5.0
- JMeter 5.1.1
- Jenkins 2.176.2
- JProfiler 11.0.1
- Docker version 18.09.2
    - Docker Desktop 2.0.0.3

## TKey 项目核心组件版本（版本号 pom.xml 为准）

- 依赖包完整列表 [pom.xml]()
- 核心：`Spring Boot 2.1.7.RELEASE`
- 其他（后续以 pom.xml 文件为主）：

```
<commons-lang3.version>3.8.1</commons-lang3.version>
<commons-text.version>1.5</commons-text.version>
<commons-collections4.version>4.2</commons-collections4.version>
<commons-io.version>2.6</commons-io.version>
<commons-codec.version>1.11</commons-codec.version>

<guava.version>27.0.1-jre</guava.version>
<okhttp.version>3.12.1</okhttp.version>
<hutool-all.version>4.5.13</hutool-all.version>
```



## 推荐使用 Postman 进行尝试性的接口测试


- Postman 的设置 302 重定向：`Settings > General > Automatically follow redirects`

默认是：ON，如果需要查看 302 的跳转中间状态，需要关闭为 OFF，不然在调试的时候如果客户端服务已经关闭，则只会看到报错信息，但是不知道是具体什么报错。

- Postman 导入我们已经准备好的请求参数，避免你直接摸索

链接地址：<https://www.getpostman.com/collections/a77c9b729b1d8d60de09>

- [Postman 导入 TKey 接口集方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-import-link.gif)
- [Postman 接口转 cURL 方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-to-curl.gif)

## Docker 环境

- 如果你还没有 Docker 环境，建议查看我们此系列教程：[CentOS 操作系统](https://github.com/cdk8s/cdk8s-team-style/tree/master/os/linux)
- TKey SSO Server 需要 Redis，Redis 信息可以在该文件进行修改：`application-dev.yml`

## 核心的用户校验逻辑

- 在 OauthController.java 类中
- 这里采用的是 REST API 校验，如果你们要直连数据库，可以在改写该逻辑
- 至于为什么要这么设计，已经在 [故意设计点（常见问题）]() 进行了说明

```
OauthUserAttribute oauthUserAttribute = requestLoginApi(oauthFormLoginParam);
```

## 登录页面改造

- TKey SSO Server 没有采用前后端分离，目前考虑是没有必要，就一个登录页面
- 使用的是 Thymeleaf 模板引擎
- 登录页面路径：`/resources/templates/login.html`














