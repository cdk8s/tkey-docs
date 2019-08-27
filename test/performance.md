

# TKey SSO Server 压力测试

## Gatling 方式压力测试

- 不带参数运行命令：

```
mvn gatling:test -Dgatling.simulationClass=test.load.oauth.TkeyPasswordGrantType
```


- 带参数运行命令：

```
mvn gatling:test -Dgatling.simulationClass=test.load.oauth.TkeyPasswordGrantType -DtotalConcurrency=1000 -DrepeatTime=10 -DinjectTime=10
```

-------------------------------------------------------------------


## JMeter 5.1 方式压力测试

- 如果 JVM 不够可以修改 bin/jmeter 文件中的：`"${HEAP:="-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m"}"`

```
cd /Users/youmeek/software/apache-jmeter-5.1.1/bin

./jmeter -n -t /Users/youmeek/TkeyPasswordGrantTypeJMeter.jmx -l /Users/youmeek/tkeyReport.jtl -e -o /Users/youmeek/htmlResult
```

-------------------------------------------------------------------

## wrk 简单压力测试


```
sudo yum groupinstall 'Development Tools'
sudo yum install -y openssl-devel git

git clone --depth=1 https://github.com/wg/wrk.git wrk
cd wrk
make

sudo cp wrk /usr/local/bin
```

```
wrk -t5 -c5 -d10s --script=/opt/post-wrk.lua --latency http://sso.cdk8s.com/sso/oauth/token
```

- post-wrk.lua

```
wrk.method = "POST"
wrk.body   = "grant_type=password&client_id=test_client_id_1&client_secret=test_client_secret_1&username=admin&password=123456"
wrk.headers["Content-Type"] = "application/x-www-form-urlencoded"
```


-------------------------------------------------------------------

## 如何继续提高 QPS

在压力测试过程中我们用 JProfile 监控了 CPU 情况，具体如下图：

![JProfile CPU](http://img.gitnavi.com/tkey/tkey-jprofile-cpu.png)

经过上图我们已经有明确的答案：`checkClientIdParam()`

在校验 client 正确性的地方，读取了 redis，这个过程如果用二级缓存，经过我们压力测试可以再提高 15~20% 左右的 QPS。但是这样改造复杂度会提高，如果 TKey SSO Server 是多节点情况下，同步变更是个麻烦事，还要再引入 MQ，我觉得不划算。中小企业不建议为了这点性能提高系统复杂度。

对于中小企业发展，最核心的还是走对业务，能有一个随时掉头，变更方向的能力，所以系统复杂度一定要尽可能不高，或者契合当前企业的发展情况。










