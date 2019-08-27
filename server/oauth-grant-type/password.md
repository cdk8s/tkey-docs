

## Postman 接口集分享

- 链接地址：<https://www.getpostman.com/collections/a77c9b729b1d8d60de09>
- [Postman 导入 TKey 接口集方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-import-link.gif)
- [Postman 接口转 cURL 方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-to-curl.gif)

## 密码模式

- **POST 请求**
- 请求地址：<http://sso.cdk8s.com:9091/sso/oauth/token>
- 参数：

```
grant_type: password
client_id: test_client_id_1
client_secret: test_client_secret_1
username: admin
password: 123456

```

- 也支持请求头验证 client：`Authorization: Basic dGVzdF9jbGllbnRfaWRfMTp0ZXN0X2NsaWVudF9zZWNyZXRfMQ==`

### cURL


```
curl -X POST \
  http://sso.cdk8s.com:9091/sso/oauth/token \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'cache-control: no-cache' \
  -d 'grant_type=password&client_id=test_client_id_1&client_secret=test_client_secret_1&username=admin&password=123456'
```

### 请求参数合法，系统返回

- 状态码 200
- JSON 数据

```
{
    "access_token": "AT-MISqrbWUxFWc1xU4e8JK2OcMgJYusF22-101",
    "token_type": "Bearer",
    "expires_in": 57600,
    "refresh_token": "RT-7UPY41g9j5K8rKBZse4qo4iP6sAbU2Df-102"
}
```


### 请求参数不合法，系统返回

- 状态码 400
- JSON 数据

```
{
    "error": "invalid request",
    "error_description": "请求类型不匹配",
    "error_uri_msg": "See the full API docs at https://github.com/cdk8s"
}
```

### 用户名密码有问题，系统返回

- 状态码 400
- JSON 数据

```
{
    "error": "invalid request",
    "error_description": "用户名或密码错误",
    "error_uri_msg": "See the full API docs at https://github.com/cdk8s"
}
```





















