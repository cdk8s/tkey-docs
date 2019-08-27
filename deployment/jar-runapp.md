
## JAR 方式

- [点击我查看整个过程 Gif 演示](http://img.gitnavi.com/tkey/tkey-runapp-jar.gif)
- 把 jar 文件和 runapp.sh 上传到 /data/jar/tkey-sso-server 目录下
- 给两个文件增加执行权限：`chmod +x runapp.sh tkey-sso-server-1.0.0.jar`
- 运行命令：`sh runapp.sh start`
- 如果需要调整目录位置、端口、启动参数（Redis 连接参数），可以自行修改 runapp.sh 文件，该脚本写得很简单，一般都可以看懂











