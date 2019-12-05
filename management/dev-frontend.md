
## TKey Client Management 开发环境

- [参考 TKey SSO Server 环境](https://github.com/cdk8s/tkey-docs/blob/master/server/dev.md)

## TKey Client Management 项目核心组件版本

- 依赖包完整列表 package.json：[Github](https://github.com/cdk8s/tkey-management-frontend/blob/master/package.json)、[Gitee](https://gitee.com/cdk8s/tkey-management-frontend/blob/master/package.json)

-------------------------------------------------------------------

## 前后端分离的场景特别说明

### 相同二级域名

- 前端：f.cdk8s.com
- 后端：b.cdk8s.com
- 这种场景下，后端可以通过写入 `.cdk8s.com` Cookie 的方式来存储 Token，前端也可以拿到 Token
    - 但是，在前后端分离情况下我更建议采用下面 `不同二级域名` 的解决办法


### 不同二级域名

- 前端：f.ffffff.com
- 后端：b.bbbbbb.com
- 这种场景下，Cookie 方式不可用
- 只能把 code 的回调地址写成前端系统，前端拿到 code 之后转发给后端，后端把 code 换取到 token 再 response 给前端，前端可以选择存储到 localstorage 中
- 这种方式麻烦的地方在于：本地环境、开发环境、测试环境、生产环境的回调配置

-------------------------------------------------------------------

## 常量参数

- **在该文件中配置了不同环境的各种需要配置的请求地址**
- globalConstant.ts

## 本地环境使用

- `.umirc.ts`


```
yarn install

yarn start

yarn build
```


## 测试环境使用

- `.umirc.test.ts`

```
yarn install

yarn start:test

yarn build:test
```


## 生产环境使用

- `.umirc.prod.ts`

```
yarn install

yarn start:prod

yarn build:prod
```














