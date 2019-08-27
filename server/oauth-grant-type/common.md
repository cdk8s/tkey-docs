


## Postman 接口集分享

- 链接地址：<https://www.getpostman.com/collections/a77c9b729b1d8d60de09>
- [Postman 导入 TKey 接口集方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-import-link.gif)
- [Postman 接口转 cURL 方法（Gif 动图）](http://img.gitnavi.com/tkey/postman-to-curl.gif)

-------------------------------------------------------------------


## 获取 access_token 对应的用户信息

- **POST 请求**
- 请求地址：<http://sso.cdk8s.com:9091/sso/oauth/userinfo>
- 参数方式
    - 请求头带有：`Authorization: Bearer AT-102-dJTLEsFLR2PbxU1l8GPx3CUS9O3Lhzdn`

- **GET 请求**
- 请求地址：<http://sso.cdk8s.com:9091/sso/oauth/userinfo?access_token=AT-102-dJTLEsFLR2PbxU1l8GPx3CUS9O3Lhzdn>


### 请求参数合法，系统返回

- 状态码 200
- JSON 数据（不带用户信息）

```
{
  "user_attribute": {},
  "grant_type": "client_credentials",
  "iat": 1451602800,
  "exp": 1451606400,
  "client_id": "test_client_id_1"
}
```


- JSON 数据（带用户信息）

```
{
  "user_attribute": {
    "email": "gitnavi@youmeek.com",
    "user_id": "7172",
    "username": "张三"
  },
  "grant_type": "authorization_code",
  "iat": 1451602800,
  "exp": 1451606400,
  "client_id": "test_client_id_1"
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

## 登出

- **GET 请求**
- 请求地址：<http://sso.cdk8s.com:9091/sso/oauth/logout?redirect_uri=http://test1.cdk8s.com:9393/client-scribejava>


### 请求参数合法，系统返回
 
- 状态码 302
- Location

```
http://test1.cdk8s.com:9393/client-scribejava
```


### 请求参数不合法，系统返回

- 停留在登录页面或跳转到 error 页面


-------------------------------------------------------------------


## 通过 refresh_token，获取新的 access_token


- **POST 请求**
- 请求地址：<http://sso.cdk8s.com:9091/sso/oauth/token>
- 参数：

```
grant_type: refresh_token
refresh_token: RT-8aI3zHbArcmzT3ukHlBQ88AdMv2NB8Aa-103
client_id: test_client_id_1
client_secret: test_client_secret_1
```

### cURL

```
curl -X POST \
  http://sso.cdk8s.com:9091/sso/oauth/token \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'cache-control: no-cache' \
  -d 'grant_type=refresh_token&refresh_token=RT-8aI3zHbArcmzT3ukHlBQ88AdMv2NB8Aa-103&client_id=test_client_id_1&client_secret=test_client_secret_1'
```


### 请求参数合法，系统返回

- 状态码 200
- JSON 数据

```
{
  "access_token": "AT-IDm312Our5Jti70BGE8RgO2qRK29blri",
  "token_type": "Bearer",
  "expires_in": 57600
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


## 验证 access_token / refresh_token


- **POST 请求**
- 请求地址：<http://sso.cdk8s.com:9091/sso/oauth/introspect>
- 参数：

```
client_id: test_client_id_1
client_secret: test_client_secret_1
token: AT-3KGHVaANf4Ppi1IhrlHTF9IKSsV7fuzY-109
token_type_hint: access_token
```

- token_type_hint，可选值
	- `access_token`
	- `refresh_token`

### 请求参数合法，系统返回

- 状态码 200
- JSON 数据

```
{
    "token_type": "Bearer",
    "grant_type": "client_credentials",
    "client_id": "test_client_id_1",
    "exp": 1561438626,
    "iat": 1561381026
}
```


###### 请求参数不合法，系统返回

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
