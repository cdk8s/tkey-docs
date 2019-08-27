
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

## Issues

TKey 是我们团队的重点项目，为了更好地发展，我们决定一开始就把项目细分化，方便后面的扩展，也方便大家阅读。
目前只开放了一个 issues 入口，集中问题，可以方便大家检索：[tkey-issues](https://github.com/cdk8s/tkey-issues)

## Documentation

- TKey 定位
    - 做国内资料最齐全的单点登录，缺什么就给大家补什么
- 认识阶段 **（必读）**
    - [单点登录系统认知与基础介绍](other/tkey-baisc.md)
    - [故意设计点（常见问题）](faq/README.md)
    - [项目结构与端口占用](other/project-structure.md)
    - [OAuth2.0 四种模式](server/oauth-grant-type/README.md)
    - [JAR 方式部署](deployment/jar-runapp.md)
    - [Docker 方式部署](deployment/docker-runapp.md)
    - [Docker Compose 方式部署](deployment/docker-compose-runapp.md)
- TKey Server 开发阶段
    - [开发改造引导](server/dev.md)
- TKey Management 开发阶段（也是前后端分离的最佳实践示例）
    - [后端开发改造引导](management/dev-backend.md)
    - [前端开发改造引导](management/dev-frontend.md)
- TKey Client Java 开发阶段
    - [自己封装的 REST Client](client/dev-rest-client.md)
    - [Spring Security 支持](client/dev-spring-security-client.md)
- 测试阶段
    - 单元测试
    - [压力测试](test/performance.md)
- 部署阶段
    - [生产注意事项](deployment/production-environment.md)
    - [部署环境搭建](deployment/deployment-core.md)
- 监控阶段
    - [Spring Boot Micrometer](deployment/micrometer.md)
    - 其他工具全在 `部署环境搭建`，请自行查看
- 线上问题诊断
    - [Actuator 在线修改 log 输出级别（Gif 动图）](http://img.gitnavi.com/tkey/actuator-update-log-level.gif)
    - [Arthas 诊断 Docker 应用](https://alibaba.github.io/arthas/docker.html#dockerjava)
    - [夜间开放端口，挑选流量远程 Debug](server/remote-debug.md)

## Share

- [Grafana Dashboard](share-file/grafana/dashboard.json)
- [Postman API](share-file/postman/tkey-sso-server-api_collection_2.1_format.json)
- [Run JAR Shell](share-file/shell/runapp.sh)


## Roadmap

- [规划版本](roadmap/README.md)

## Changelog

- [版本更新](changelog/README.md)

## Issues

- [去提问](https://github.com/cdk8s/tkey-issues/issues)

## Contributors

- 暂无
- 欢迎 pull request

## Adopters

- [去申请](https://github.com/cdk8s/tkey-issues/issues/1)

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
