

## Docker Compose 启动 TKey SSO Server + Redis

- git clone 项目
- 保持在项目根目录，输入：`mvn clean install -DskipTests`
- 保持在项目根目录，输入：`docker-compose -f ./docker-compose-quickstart.yml up --build -d`

## 测试

- cURL 测试结果：

```
curl -X POST \
  http://sso.cdk8s.com:9091/sso/oauth/token \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'cache-control: no-cache' \
  -d 'grant_type=password&client_id=test_client_id_1&client_secret=test_client_secret_1&username=admin&password=123456'
```
