## TKey Client 开发环境

- [参考 TKey SSO Server 环境](https://github.com/cdk8s/tkey-docs/blob/master/server/dev.md)

## TKey Client 项目核心组件版本

- [参考 TKey SSO Server 环境](https://github.com/cdk8s/tkey-docs/blob/master/server/dev.md)


## Maven 中央库已发布

- 中央库地址：<https://search.maven.org/search?q=tkey-sso-client-starter-rest>
- Maven

```
<tkey-sso-client-starter-rest.version>1.0.0</tkey-sso-client-starter-rest.version>


<dependency>
    <groupId>com.cdk8s.tkey</groupId>
    <artifactId>tkey-sso-client-starter-rest</artifactId>
    <version>${tkey-sso-client-starter-rest.version}</version>
</dependency>
```

- Gradle Groovy DSL：

```
implementation 'com.cdk8s.tkey:tkey-sso-client-starter-rest:1.0.0'
```

- Gradle Kotlin DSL

```
compile("com.cdk8s.tkey:tkey-sso-client-starter-rest:1.0.0")
```