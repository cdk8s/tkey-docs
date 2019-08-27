

## 配置 IntelliJ IDEA 远程 Debug


![debug 配置](http://img.gitnavi.com/tkey/remote-debug-1.png)


- **复制这个 VM 配置**

```
-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005
```


## 调整应用启动参数

- 在 应用的原有 JAVA_OPTS 参数基础上补加，效果如下：

```
JAVA_OPTS="-Xms512m -Xmx2048m -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
```


## 启动本地项目

![debug 启动](http://img.gitnavi.com/tkey/remote-debug-2.png)

- 然后在项目代码中打断点，跟平时本地 debug 一样


![debug 住断点效果](http://img.gitnavi.com/tkey/remote-debug-3.png)
