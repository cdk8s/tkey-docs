
## Git

- Github：<https://github.com/cdk8s/tkey-docs>
- Gitee：<https://gitee.com/cdk8s/tkey-docs>
- Gitbook：<https://160668873.gitbook.io/tkey-docs/>

## Hosts

```
127.0.0.1 sso.cdk8s.com
127.0.0.1 test1.cdk8s.com
127.0.0.1 test2.cdk8s.com
127.0.0.1 redis.cdk8s.com
127.0.0.1 mysql.cdk8s.com
127.0.0.1 management.cdk8s.com
127.0.0.1 management-frontend.cdk8s.com
```

## Architecture

![架构图](http://img.gitnavi.com/tkey/tkey-sso-architecture.jpg)

- 上图的视频讲解：[B 站](https://www.bilibili.com/video/av65883281/)、[腾讯视频](https://v.qq.com/x/page/e0920wdqe7v.html)
- OAuth2.0 授权码模式细节时序图可以查看：[点击我查看](http://img.gitnavi.com/tkey/tkey-oauth.png)

## Documentation

- 我们统一了 TKey 项目的所有文档，方便大家查看
    - Github：<https://github.com/cdk8s/tkey-docs>
    - Gitee：<https://gitee.com/cdk8s/tkey-docs>
    - Gitbook：<https://160668873.gitbook.io/tkey-docs/>
- **认识阶段 （必读）**
    - 单点登录系统认知与基础介绍：[Github](https://github.com/cdk8s/tkey-docs/blob/master/other/tkey-baisc.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/other/tkey-baisc.md)
    - 故意设计点（常见问题）：[Github](https://github.com/cdk8s/tkey-docs/blob/master/faq/README.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/faq/README.md)
    - 项目结构与端口占用：[Github](https://github.com/cdk8s/tkey-docs/blob/master/other/project-structure.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/other/project-structure.md)
    - OAuth2.0 四种模式：[Github](https://github.com/cdk8s/tkey-docs/blob/master/server/oauth-grant-type/README.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/server/oauth-grant-type/README.md)
    - JAR 方式部署：[Github](https://github.com/cdk8s/tkey-docs/blob/master/deployment/jar-runapp.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/deployment/jar-runapp.md)
    - Docker 方式部署：[Github](https://github.com/cdk8s/tkey-docs/blob/master/deployment/docker-runapp.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/deployment/docker-runapp.md)
    - Docker Compose 方式部署：[Github](https://github.com/cdk8s/tkey-docs/blob/master/deployment/docker-compose-runapp.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/deployment/docker-compose-runapp.md)
- TKey Server 开发阶段
    - 开发改造引导：[Github](https://github.com/cdk8s/tkey-docs/blob/master/server/dev.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/server/dev.md)
- TKey Management 开发阶段（也是前后端分离的最佳实践示例）
    - 后端开发改造引导：[Github](https://github.com/cdk8s/tkey-docs/blob/master/management/dev-backend.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/management/dev-backend.md)
    - 前端开发改造引导：[Github](https://github.com/cdk8s/tkey-docs/blob/master/management/dev-frontend.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/management/dev-frontend.md)
- TKey Client Java 开发阶段
    - 自己封装的 REST Client：[Github](https://github.com/cdk8s/tkey-docs/blob/master/client/dev-rest-client.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/client/dev-rest-client.md)
    - Spring Security 支持：[Github](https://github.com/cdk8s/tkey-docs/blob/master/client/dev-spring-security-client.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/client/dev-spring-security-client.md)
- 测试阶段
    - 单元测试：[Github](https://github.com/cdk8s/tkey/blob/master/src/test/java/com/cdk8s/tkey/server/controller/AuthorizationCodeByFormTest.java)、[Gitee](https://gitee.com/cdk8s/tkey/blob/master/src/test/java/com/cdk8s/tkey/server/controller/AuthorizationCodeByFormTest.java)
    - 压力测试：[Github](https://github.com/cdk8s/tkey-docs/blob/master/test/performance.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/test/performance.md)
- 部署阶段
    - 生产注意事项：[Github](https://github.com/cdk8s/tkey-docs/blob/master/deployment/production-environment.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/deployment/production-environment.md)
    - 部署环境搭建：[Github](https://github.com/cdk8s/tkey-docs/blob/master/deployment/deployment-core.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/deployment/deployment-core.md)
- 监控阶段
    - Spring Boot Micrometer：[Github](https://github.com/cdk8s/tkey-docs/blob/master/deployment/micrometer.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/deployment/micrometer.md)
    - 其他工具全在 `部署环境搭建`，请自行查看
- 线上问题诊断
    - [Actuator 在线修改 log 输出级别（Gif 动图）](http://img.gitnavi.com/tkey/actuator-update-log-level.gif)
    - [Arthas 诊断 Docker 应用](https://alibaba.github.io/arthas/docker.html#dockerjava)
    - 夜间开放端口，挑选流量远程 Debug：[Github](https://github.com/cdk8s/tkey-docs/blob/master/server/remote-debug.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/server/remote-debug.md)


## TKey Client

- Java 前后端分离最佳实践
    - TKey SSO Client Management Backend：[Github](https://github.com/cdk8s/tkey-management)、[Gitee](https://gitee.com/cdk8s/tkey-management)
    - TKey SSO Client Management Frontend：[Github](https://github.com/cdk8s/tkey-management-frontend)、[Gitee](https://gitee.com/cdk8s/tkey-management)
    - Angular、Vue 的前后端分离版本会在稍后几周发出来
- Java REST API 客户端：[Github](https://github.com/cdk8s/tkey-client-java)、[Gitee](https://gitee.com/cdk8s/tkey-client-java)
- Java Spring Security 客户端：[Github](https://github.com/cdk8s/tkey-client-java-spring-security)、[Gitee](https://gitee.com/cdk8s/tkey-client-java-spring-security)
- C#（暂缺）
- GO（暂缺）
- PHP（暂缺）
- Python（暂缺）
- Ruby（暂缺）
- Node.js（暂缺）

## Share

- Grafana Dashboard：[Github](https://github.com/cdk8s/tkey-docs/blob/master/share-file/grafana/dashboard.json)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/share-file/grafana/dashboard.json)
- Postman API：[Github](https://github.com/cdk8s/tkey-docs/blob/master/share-file/postman/tkey-sso-server-api_collection_2.1_format.json)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/share-file/postman/tkey-sso-server-api_collection_2.1_format.json)
- Run JAR Shell：[Github](https://github.com/cdk8s/tkey-docs/blob/master/share-file/shell/runapp.sh)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/share-file/shell/runapp.sh)


## Roadmap

- 规划版本：[Github](https://github.com/cdk8s/tkey-docs/blob/master/roadmap/README.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/roadmap/README.md)

## Changelog

- 版本更新：[Github](https://github.com/cdk8s/tkey-docs/blob/master/changelog/README.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/changelog/README.md)


## Issues

- 目前只开放了一个 issues 入口，集中问题，可以方便大家检索。
- 去提问：[Github](https://github.com/cdk8s/tkey-issues)、[Gitee](https://gitee.com/cdk8s/tkey-issues)

## Contributors

- 暂无
- 欢迎 pull request

## Adopters

- 去申请：[Github](https://github.com/cdk8s/tkey-issues/issues/1)、[Gitee](https://gitee.com/cdk8s/tkey-issues/issues/1)

## Sponsors

- 暂无

## Backer

- [我要喝喜茶 Orz..](http://www.youmeek.com/donate/)


## Join

- 邮箱：`cdk8s#qq.com`
- 博客：<https://cdk8s.github.io/>
- Github：<https://github.com/cdk8s>
- Gitee：<https://gitee.com/cdk8s>
- 公众号

![公众号](http://img.gitnavi.com/markdown/cdk8s_qr_300px.png)


## Jobs

- 我们在广州
- 有广州或深圳的合作、Offer 欢迎联系我们
- 邮箱：`cdk8s#qq.com`
- 公众号：`联系我们`

## Thanks

- [IntelliJ IDEA](https://www.jetbrains.com/idea/)
- [CAS](https://github.com/apereo/cas)
- [Okta](https://www.okta.com/)


## Copyright And License

- Copyright (c) CDK8S. All rights reserved.
- Licensed under the **MIT** license.
- **再次强调： 因为是 MIT 协议，大家有不满意的，除了 PR 也可以 fork 后自己尽情改造!**



