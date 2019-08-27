* 认识阶段 (必读)
  * [单点登录系统认知与基础介绍](other/tkey-baisc.md)
  * [故意设计点（常见问题）](faq/README.md)
  * [项目结构与端口占用](other/project-structure.md)
  * [OAuth2.0 四种模式](server/oauth-grant-type/README.md)
  * [JAR 方式部署](deployment/jar-runapp.md)
  * [Docker 方式部署](deployment/docker-runapp.md)
  * [Docker Compose 方式部署](deployment/docker-compose-runapp.md)
* TKey Server 开发阶段
  * [开发改造引导](server/dev.md)
* TKey Management 开发阶段（也是前后端分离的最佳实践示例）
  * [后端开发改造引导](management/dev-backend.md)
  * [前端开发改造引导](management/dev-frontend.md)
* TKey Client Java 开发阶段
  * [自己封装的 REST Client](client/dev-rest-client.md)
  * [Spring Security 支持](client/dev-spring-security-client.md)
* 测试阶段
  * 单元测试
  * [压力测试](test/performance.md)
* 部署阶段
  * [生产注意事项](deployment/production-environment.md)
  * [部署环境搭建](deployment/deployment-core.md)
* 监控阶段
  * [Spring Boot Micrometer](deployment/micrometer.md)
  * 其他工具全在 `部署环境搭建`，请自行查看
* 线上问题诊断
  * [Actuator 在线修改 log 输出级别（Gif 动图）](http://img.gitnavi.com/tkey/actuator-update-log-level.gif)
  * [Arthas 诊断 Docker 应用](https://alibaba.github.io/arthas/docker.html#dockerjava)
  * [夜间开放端口，挑选流量远程 Debug](server/remote-debug.md)