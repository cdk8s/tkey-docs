

## Postman 接口集分享

- 链接地址：<https://www.getpostman.com/collections/a77c9b729b1d8d60de09>
- [Postman 导入 TKey 接口集方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-import-link.gif)
- [Postman 接口转 cURL 方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-to-curl.gif)

## 授权码模式


### 用户未认证，跳转登录页面

- **GET 请求**（业务系统重定向）
- 请求地址：<http://sso.cdk8s.com:9091/sso/oauth/authorize>
- URL 参数

```
response_type: code
client_id: test_client_id_1
redirect_uri: http://test1.cdk8s.com:9393/client-scribejava/user?id=123456&name=cdk8s
state: 12345
```

- 完整 demo：

```
http://sso.cdk8s.com:9091/sso/oauth/authorize?response_type=code&client_id=test_client_id_1&redirect_uri=http%3A%2F%2Ftest1.cdk8s.com%3A9393%2Fclient-scribejava%2FcodeCallback%3Fredirect_uri%3Dhttp%253A%252F%252Ftest1.cdk8s.com%253A9393%252Fclient-scribejava%252Fuser%253Fid%253D123456%2526name%253Dcdk8s
```

- 其中，最让人看不懂的是：`http%3A%2F%2Ftest1.cdk8s.com%3A9393%2Fclient-scribejava%2FcodeCallback%3Fredirect_uri%3Dhttp%253A%252F%252Ftest1.cdk8s.com%253A9393%252Fclient-scribejava%252Fuser%253Fid%253D123456%2526name%253Dcdk8s`
    - 这里进行了 URL 转码
    - 其中还有一个子参数：`%3Fredirect_uri%3Dhttp%253A%252F%252Ftest1.cdk8s.com%253A9393%252Fclient-scribejava%252Fuser%253Fid%253D123456%2526name%253Dcdk8s`
        - 该参数也进行了一个 URL 转码
        - 这个地址也就是用户最终登录后的跳转地址
    - Spring Security 的客户端没有这种情况，是因为它内部做了 cookie 的映射，所以最终重定向的地址不是根据 url 参数来的
    - 我们封装的 tkey-sso-client-scribejava 则是完全根据 url 参数来做最后登录成功的跳转
- state 可以为空


### 用户提交的用户名和密码不匹配

- 停留在登录页面，显示登录错误信息

### 用户提交的用户名和密码匹配

- 301 重定向到：`http://test1.cdk8s.com:9393/client-scribejava/codeCallback?redirect_uri=http%3A%2F%2Ftest1.cdk8s.com%3A9393%2Fclient-scribejava%2Fuser%3Fid%3D123456%26name%3Dcdk8s`

-------------------------------------------------------------------

## 业务系统回调接口触发授权码第二步，通过 code 换取 token（核心点）

- **POST 请求**
- 请求地址：<http://sso.cdk8s.com:9091/sso/oauth/token>
- 参数：

```
grant_type: authorization_code
code: OC-106-uUddPxoWCEa4NBO5GaVIRJOTZLlWbHNr
redirect_uri: http://test1.cdk8s.com:9393/client-scribejava/user?id=123456&name=cdk8s
client_id: test_client_id_1
client_secret: test_client_secret_1
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

-------------------------------------------------------------------


## 业务系统通过 access_token 换取用户信息（核心点）

- **GET 请求**
- 请求地址：<http://sso.cdk8s.com:9091/sso/oauth/userinfo>
- 参数：

```
access_token: AT-dJTLEsFLR2PbxU1l8GPx3CUS9O3Lhzdn-102
```


### 请求参数合法，系统返回

- 状态码 200
- JSON 数据

```
{
    "username": "admin",
    "name": "admin",
    "id": "111222333",
    "user_id": "111222333",
    "user_attribute": {
        "email": "admin@cdk8s.com",
        "user_id": "111222333",
        "username": "admin"
    },
    "grant_type": "authorization_code",
    "client_id": "test_client_id_1",
    "iat": 1562134212,
    "exp": 1562191812
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













