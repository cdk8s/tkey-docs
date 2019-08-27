

## 相应组件部署

- [部署说明](https://github.com/cdk8s/tkey-docs/blob/master/deployment/deployment-core.md)

## 引入 Prometheus

```
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```


访问：<http://sso.cdk8s.com:19091/tkey-actuator/actuator/prometheus>

可以看到 prometheus 暴露出来的埋点信息


## Micrometer Tag

```
$instance - Instance Name
$application - Spring Boot Application Name
$hikaricp - HikariCP Connection Pool Name
```

