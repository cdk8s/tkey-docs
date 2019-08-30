## TKey Client 开发环境

- [参考 TKey SSO Server 环境](https://github.com/cdk8s/tkey-docs/blob/master/server/dev.md)

## TKey Client 项目核心组件版本

- [参考 TKey SSO Server 环境](https://github.com/cdk8s/tkey-docs/blob/master/server/dev.md)


## Spring Boot 1.5.x 和 2.1.x 的区别

- Spring Boot 1.5.x 搭配 Spring Security 4 一起使用
- Spring Boot 2.1.x 搭配 Spring Security 5 一起使用
- Spring Security 4 和 5 变化比较大，所以分开了两个项目进行演示
- 虽然 TKey SSO 支持 Spring Security OAuth2 客户端，但是因为 Spring Security 封装过多，较庞大，所以还是推荐你使用 TKey 自己的 Client，可以控制的细节内容会多得多
