

## Postman 接口集分享

- 链接地址：<https://www.getpostman.com/collections/a77c9b729b1d8d60de09>
- [Postman 导入 TKey 接口集方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-import-link.gif)
- [Postman 接口转 cURL 方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-to-curl.gif)

## 客户端模式

- **GET 请求**
- 请求地址：<http://sso.cdk8s.com:9091/sso/oauth/token>
- 参数：

```
grant_type: client_credentials
client_id: test_client_id_1
client_secret: test_client_secret_1
```

- 也支持请求头验证 client：`Authorization: Basic dGVzdF9jbGllbnRfaWRfMTp0ZXN0X2NsaWVudF9zZWNyZXRfMQ==`


### cURL

```
curl -X GET \
  'http://sso.cdk8s.com:9091/sso/oauth/token?grant_type=client_credentials&client_id=test_client_id_1&client_secret=test_client_secret_1' \
  -H 'cache-control: no-cache'
```


### 请求参数合法，系统返回

- 状态码 200
- JSON 数据

```
{
    "access_token": "AT-102-dJTLEsFLR2PbxU1l8GPx3CUS9O3Lhzdn",
    "token_type": "Bearer",
    "expires_in": 57600,
    "refresh_token": "RT-mTeOPJHDbcDeeUhRM0V52giRgiisu6ar-102"
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




















