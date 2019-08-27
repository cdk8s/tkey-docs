
## TKey Client Management 开发环境

- macOS High Sierra 10.13.6 
- Node 10.14.2
- npm 6.4.1
- Yarn 1.12.3

## TKey Client Management 项目核心组件版本

- 依赖包完整列表 [package.json]()


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
- 这种方式麻烦的地方在于：
    - 本地环境、开发环境、测试环境、生产环境的回调配置



## 常量参数

- globalConstant.ts

## 本地环境

- `.umirc.ts`


```
yarn install

yarn start

yarn build
```


## 测试环境

- `.umirc.test.ts`

```
yarn install

yarn start:test

yarn build:test
```














