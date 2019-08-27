

## Postman 接口集分享

- 链接地址：<https://www.getpostman.com/collections/a77c9b729b1d8d60de09>
- [Postman 导入 TKey 接口集方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-import-link.gif)
- [Postman 接口转 cURL 方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-to-curl.gif)

## 简化模式

- **GET 请求**
- 请求地址：<http://sso.cdk8s.com:9091/sso/oauth/authorize>
- 参数：

```
response_type: token
client_id: test_client_id_1
redirect_uri: http://www.gitnavi.com
```

### 浏览器访问

- <http://sso.cdk8s.com:9091/sso/oauth/authorize?response_type=token&client_id=test_client_id_1&redirect_uri=http://www.gitnavi.com>

### 请求参数合法，系统返回
 
- 状态码 302
- Location

```
http://www.gitnavi.com#access_token=AT-TxshSaBDm0RMxFEw1osvnFE7PIJmBvWU-103&token_type=Bearer&expires_in=57600&refresh_token=RT-WHD9vlVxiB4Q2XB0OnCrXHeLnptyIbPv-104
```


### 请求参数不合法，系统返回

- 停留在登录页面或跳转到 error 页面




















