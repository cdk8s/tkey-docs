
# 生产提醒

- 请不要轻视安全问题，这是一个永远永远都要放心上的问题
- 请结合该篇一起阅读：
    - 故意设计点（常见问题）：[Github](https://github.com/cdk8s/tkey-docs/blob/master/faq/README.md)、[Gitee](https://gitee.com/cdk8s/tkey-docs/blob/master/faq/README.md)

## 必备要求

1. 全网 HTTPS，全网 HTTPS，全网 HTTPS
2. 不要明文存储用户密码，不要明文，不要明文（前端 MD5 后再传输）
4. Cookie 的 httpOnly 和 secure 都为 true


## 可以额外改造的

3. Token 绑定 IP 和 User-Agent
5. 客户端必传 state 防止 CSRF
5. 增加多因素认证
6. 增加异地登入审查
6. 分析异常登入记录

## 关于 Client 信息管理

- 在 TKey Server 中有一个类：`ApplicationTestDataInitRunner.java` 会在本地开发环境、测试环境生成一个测试专用的 Client
- 如果你已经准备上对外测试、生产记得梳理下 Client 的管理。默认是应该在 TKey Management 项目中进行管理 Client，而 TKey Server 只是读取 Client
- TKey Management 中也有一个类：`ApplicationTestDataInitRunner.java` 会在本地开发环境、测试环境启动的时候读取 H2 数据库，初始化 Client 到 Redis 中
- 以上两个人类都没有强加在 Prod 环境，担心开发者无意识地操作，造成生产事故，所以大家如果需要这个初始化，需要自己评估，并且开启在 Prod 环境下







