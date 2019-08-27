

## 手工构建镜像

- git clone 项目
- 保持在项目根目录，输入：`mvn clean install -DskipTests`
- 保持在项目根目录，输入：`docker build . -t cdk8s/tkey-sso-server`
- 查看镜像大小：`docker images`

```
cdk8s/tkey-sso-server        latest                    e0eefff8590b        4 seconds ago       205MB
```


## 启动 TKey SSO Server（使用外部 Redis）

- 启动容器：（挂载路径大家自行修改）

```
docker run -d \
-p 9091:9091 \
--add-host redis.cdk8s.com:192.168.0.107 \
--name=tkey-sso-server --hostname=tkey-sso-server \
--restart=unless-stopped \
-v /Users/youmeek/docker_data/logs/:/logs/ \
-v /Users/youmeek/docker_data/headDump/:/data/headDump/ \
-e SPRING_PROFILES_ACTIVE=test \
-e SPRING_REDIS_DATABASE=0 \
-e SPRING_REDIS_PORT=6379 \
-e SPRING_REDIS_HOST=redis.cdk8s.com \
-e SPRING_REDIS_PASSWORD=123456 \
-e TKEY_NODE_NUMBER=10 \
-e JAVA_OPTS="-Xms1024m -Xmx1024m -XX:MetaspaceSize=124m -XX:MaxMetaspaceSize=224m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/data/headDump" \
cdk8s/tkey-sso-server:latest
```

## 测试

- cURL 测试结果：

```
curl -X POST \
  http://sso.cdk8s.com:9091/sso/oauth/token \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'cache-control: no-cache' \
  -d 'grant_type=password&client_id=test_client_id_1&client_secret=test_client_secret_1&username=admin&password=123456'
```