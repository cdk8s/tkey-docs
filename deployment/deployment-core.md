
# TKey 环境

- CentOS 7.5 x64

## 修改 SSH 端口

- 配置文件介绍（记得先备份）：`sudo vim /etc/ssh/sshd_config`
- 打开这一行注释：Port 22
	- 自定义端口选择建议在万位的端口，如：10000-65535之间，假设这里我改为 52221
- CentOS 7：添加端口：`firewall-cmd --zone=public --add-port=52221/tcp --permanent`
	- 重启防火墙：`firewall-cmd --reload`
- CentOS 7 命令：`systemctl restart sshd.service`

## 设置免密登录

- 在 A 机器上输入命令：`ssh-keygen`
	- 根据提示回车，共有三次交互提示，都回车即可。
- 生成的密钥目录在：**/root/.ssh**
- 写入：`cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys`
- 测试：`ssh localhost`

## 安装 ansible

- CentOS：`sudo yum install -y ansible`
	- 查看版本：`ansible --version`
- 编辑配置文件：`vim /etc/ansible/hosts`，在文件尾部添加：

```
[local]
172.16.16.4 ansible_ssh_port=52221
```

- 让远程所有主机都执行 `ps` 命令，输出如下

```
ansible all -a 'ps'
```



## 基础设置

- 禁用
    - firewalld
    - selinux
    - swap
- 安装
    - zip unzip lrzsz git wget htop deltarpm 
    - zsh vim
    - docker docker-compose

- 创建脚本文件：`vim /opt/install-basic-playbook.yml`

```
- hosts: all
  remote_user: root
  tasks:
    - name: Disable SELinux at next reboot
      selinux:
        state: disabled
        
    - name: disable firewalld
      command: "{{ item }}"
      with_items:
         - systemctl stop firewalld
         - systemctl disable firewalld
         - echo "vm.swappiness = 0" >> /etc/sysctl.conf
         - swapoff -a
         - sysctl -w vm.swappiness=0
         
    - name: install-epel
      command: "{{ item }}"
      with_items:
         - yum install -y epel-release
         
    - name: install-basic
      command: "{{ item }}"
      with_items:
         - yum install -y zip unzip lrzsz git wget htop deltarpm
         
    - name: install-zsh
      shell: "{{ item }}"
      with_items:
         - yum install -y zsh
         - wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
         - chsh -s /bin/zsh root
         
    - name: install-vim
      shell: "{{ item }}"
      with_items:
         - yum install -y vim
         - curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc
         
    - name: install-docker
      shell: "{{ item }}"
      with_items:
         - yum install -y yum-utils device-mapper-persistent-data lvm2
         - yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
         - yum makecache fast
         - yum install -y docker-ce docker-ce-cli containerd.io
         - systemctl start docker.service
         - docker run hello-world
         
    - name: install-docker-compose
      shell: "{{ item }}"
      with_items:
         - curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
         - chmod +x /usr/local/bin/docker-compose
         - docker-compose --version
         - systemctl restart docker.service
         - systemctl enable docker.service
```

- 执行：`ansible-playbook /opt/install-basic-playbook.yml`

## Docker 镜像源

- `vim /etc/docker/daemon.json`，增加如下内容：
 
``` bash
{
  "registry-mirrors": ["https://ldhc17y9.mirror.aliyuncs.com"]
}
```
 
- `sudo systemctl daemon-reload`
- `sudo systemctl restart docker`


## 离线安装 jdk

- 下载 jdk 到 /opt 目录下
- 创建脚本文件：`vim /opt/jdk8-playbook.yml`

```
- hosts: all
  remote_user: root
  vars:
    java_install_folder: /usr/local
    file_name: jdk-8u212-linux-x64.tar.gz
  tasks:
    - name: copy jdk
      copy: src=/opt/{{ file_name }} dest={{ java_install_folder }}
      
    - name: tar jdk
      shell: chdir={{ java_install_folder }} tar zxf {{ file_name }}
      
    - name: set JAVA_HOME
      blockinfile: 
        path: /root/.zshrc
        marker: "#{mark} JDK ENV"
        block: |
          JAVA_HOME={{ java_install_folder }}/jdk1.8.0_212
          JRE_HOME=$JAVA_HOME/jre
          PATH=$PATH:$JAVA_HOME/bin
          CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
          export JAVA_HOME
          export JRE_HOME
          export PATH
          export CLASSPATH
    
    - name: source zshrc
      shell: source /root/.zshrc
         
    - name: Clean file
      file:
        state: absent
        path: "{{ java_install_folder }}/{{ file_name }}" 
```


- 执行命令：`ansible-playbook /opt/jdk8-playbook.yml`



## 安装 maven


- 下载 maven 到 /opt 目录下：`wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.zip`
- 创建脚本文件：`vim /opt/maven-playbook.yml`

```
- hosts: all
  remote_user: root
  vars:
    maven_install_folder: /usr/local
    file_name: apache-maven-3.6.1-bin.zip
  tasks:
    - name: copy maven
      copy: src=/opt/{{ file_name }} dest={{ maven_install_folder }}
      
    - name: unzip maven
      shell: chdir={{ maven_install_folder }} unzip {{ file_name }}
      
    - name: set MAVEN_HOME
      blockinfile: 
        path: /root/.zshrc
        marker: "#{mark} MAVEN ENV"
        block: |
            MAVEN_HOME={{ maven_install_folder }}/apache-maven-3.6.1
            M3_HOME={{ maven_install_folder }}/apache-maven-3.6.1
            PATH=$PATH:$M3_HOME/bin
            MAVEN_OPTS="-Xms256m -Xmx356m"
            export M3_HOME
            export MAVEN_HOME
            export PATH
            export MAVEN_OPTS
    
    - name: source zshrc
      shell: source /root/.zshrc
         
    - name: Clean file
      file:
        state: absent
        path: "{{ maven_install_folder }}/{{ file_name }}" 
```


- 执行命令：`ansible-playbook /opt/maven-playbook.yml`

```
修改 Maven 源
mkdir -p /data/local_maven_repository
vim /usr/local/apache-maven-3.6.1/conf/settings.xml



<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">


    <localRepository>/data/local_maven_repository</localRepository>

    <pluginGroups>
    </pluginGroups>

    <proxies>
    </proxies>

    <servers>
    </servers>

    <profiles>
        <profile>
            <id>aliyun</id>
            <repositories>
                <repository>
                    <id>aliyun</id>
                    <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
            </repositories>
            <pluginRepositories>
                <pluginRepository>
                    <id>aliyun</id>
                    <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>
        <profile>
            <id>maven</id>
            <repositories>
                <repository>
                    <id>maven</id>
                    <url>https://repo.maven.apache.org/maven2/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
            </repositories>
            <pluginRepositories>
                <pluginRepository>
                    <id>maven</id>
                    <url>https://repo.maven.apache.org/maven2/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>
    </profiles>

    <activeProfiles>
        <activeProfile>aliyun</activeProfile>
    </activeProfiles>

</settings>
```



## 安装 node

- 创建脚本文件：`vim /opt/node-playbook.yml`

```
- hosts: all
  remote_user: root
  tasks:
    - name: uninstall-node
      shell: yum remove -y nodejs npm

    - name: curl node
      shell: "curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash -"
      
    - name: install node
      command: "{{ item }}"
      with_items:
         - yum -y install nodejs

    - name: curl yarn
      shell: "curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo"
          
    - name: install yarn
      command: "{{ item }}"
      with_items:
         - yum -y install yarn
```


- 执行命令：`ansible-playbook /opt/node-playbook.yml`

## 安装 Jenkins

- 创建脚本文件：`vim /opt/jenkins-playbook.yml`

```
- hosts: all
  remote_user: root
  tasks:
    - name: wget
      shell: wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

    - name: rpm import
      shell: rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

    - name: install
      shell: yum install -y jenkins
```

- 执行命令：`ansible-playbook /opt/jenkins-playbook.yml`
- 在安装完默认推荐的插件后还需要额外安装：
    - `Maven Integration`
- 设置 `全局工具配置` [点击我查看设置方法](https://upload-images.jianshu.io/upload_images/19119711-17eac75f51516b69.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

-------------------------------------------------------------------

## 安装 Redis 5.x（Docker）

```
mkdir -p /data/docker/redis/conf /data/docker/redis/db
chmod -R 777 /data/docker/redis
```

```
创建配置文件：
vim /data/docker/redis/conf/redis.conf



bind 0.0.0.0
requirepass 123456
protected-mode yes

port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize no
supervised no
pidfile /data/redis_6379.pid
loglevel notice
logfile ""
databases 16
always-show-logo yes
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /data
replica-serve-stale-data yes
replica-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
replica-priority 100
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
replica-lazy-flush no
appendonly no
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble yes
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
stream-node-max-bytes 4096
stream-node-max-entries 100
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit replica 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
dynamic-hz yes
aof-rewrite-incremental-fsync yes
rdb-save-incremental-fsync yes
```

- 启动镜像：

```
docker run \
    --name cdk8s-redis \
    --restart always \
    -d -it -p 6379:6379 \
    -v /data/docker/redis/conf/redis.conf:/etc/redis/redis.conf \
    -v /data/docker/redis/db:/data \
    redis:5 \
    redis-server /etc/redis/redis.conf
```

-------------------------------------------------------------------

## 安装 MySQL（Docker）

```
mkdir -p /data/docker/mysql/datadir /data/docker/mysql/conf /data/docker/mysql/log
```

```
创建配置文件：
vim /data/docker/mysql/conf/mysql-1.cnf

# 该编码设置是我自己配置的
[mysql]
default-character-set = utf8mb4

# 下面内容是 docker mysql 默认的 start
[mysqld]
max_connections = 500
pid-file = /var/run/mysqld/mysqld.pid
socket = /var/run/mysqld/mysqld.sock
datadir = /var/lib/mysql
#log-error = /var/log/mysql/error.log
# By default we only accept connections from localhost
#bind-address = 127.0.0.1
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
# 上面内容是 docker mysql 默认的 end

# 下面开始的内容就是我自己配置的
log-error=/var/log/mysql/error.log
default-storage-engine = InnoDB
collation-server = utf8mb4_unicode_520_ci
init_connect = 'SET NAMES utf8mb4'
character-set-server = utf8mb4
# 表名大小写敏感 0 是区分大小写，1 是不分区，全部采用小写
lower_case_table_names = 1
max_allowed_packet = 50M
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION

# 避免在 dump 命令中加上密码后提示：Using a password on the command line interface can be insecure
[mysqldump]
user=root
password=123456
```

```
chmod -R 777 /data/docker/mysql/datadir /data/docker/mysql/log
chown -R 0:0 /data/docker/mysql/conf
```


```
docker run \
	--name cdk8s-mysql \
	--restart always \
	-d \
	-p 3306:3306 \
	-v /data/docker/mysql/datadir:/var/lib/mysql \
	-v /data/docker/mysql/log:/var/log/mysql \
	-v /data/docker/mysql/conf:/etc/mysql/conf.d \
	-e MYSQL_ROOT_PASSWORD=123456 \
	mysql:5.7
```

-------------------------------------------------------------------


## 安装 Prometheus（Docker）

```

创建配置文件：
mkdir -p /data/docker/prometheus/conf && vim /data/docker/prometheus/conf/prometheus.yml
chmod -R 777 /data/docker/prometheus

# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"


scrape_configs:
  - job_name: 'cdk8s-sso'
    metrics_path: '/tkey-actuator/actuator/prometheus'
    static_configs:
    - targets: ['172.16.16.4:19091']
```


- 启动

```
docker run \
    -d \
    --name cdk8s-prometheus \
    --restart always \
    -p 9090:9090 \
    -v /data/docker/prometheus/conf/prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus
```

-------------------------------------------------------------------


## 安装 Grafana（Docker）


```
mkdir -p /data/docker/grafana/data
chmod -R 777 /data/docker/grafana/data

docker run \
    -d \
    --name cdk8s-grafana \
    --restart always \
    -p 3000:3000 \
    -v /data/docker/grafana/data:/var/lib/grafana \
    grafana/grafana
```

- <http://127.0.0.1:3000>
- 默认管理账号；admin，密码：admin，第一次登录后需要修改密码

-------------------------------------------------------------------

## 安装 Portainer（Docker）


```
mkdir -p /data/docker/portainer
chmod -R 777 /data/docker/portainer
```

- 创建文件：`vim docker-compose.yml`

```
version: '3'
services:
  portainer:
    container_name: portainer
    image: portainer/portainer
    volumes:
      - /data/docker/portainer:/data
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "9000:9000"
```

- 启动：`docker-compose up -d`
- 浏览器访问访问：<http://182.61.44.40:9000>
- 第一次启动会让你创建用户名和密码。第二步就是配置管理哪里的 docker 容器，我这里选择：local


-------------------------------------------------------------------


## 安装 Nginx（Docker）

```
mkdir -p /data/docker/nginx/logs /data/docker/nginx/conf /data/docker/nginx/html
chmod -R 777 /data/docker/nginx
```

```
创建配置文件：
vim /data/docker/nginx/conf/nginx.conf




worker_processes      1;

events {
  worker_connections  1024;
}

http {
  include             mime.types;
  default_type        application/octet-stream;

  sendfile on;
  keepalive_timeout   65;

  gzip on;
  gzip_buffers 8 16k;
  gzip_min_length 512;
  gzip_disable "MSIE [1-6]\.(?!.*SV1)";
  gzip_http_version 1.1;
  gzip_types   text/plain text/css application/javascript application/x-javascript application/json application/xml;

  server {
    listen            80;
    server_name       localhost 127.0.0.1 191.112.221.203;

    location / {
      root            /usr/share/nginx/html;
      index           index.html index.htm;
    }
  }
}
```


- 运行容器：

```
docker run \
    -d \
    --name cdk8s-nginx \
    --restart always \
    -p 80:80 \
    -v /data/docker/nginx/logs:/var/log/nginx \
    -v /data/docker/nginx/html:/data/html \
    -v /data/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf:ro \
    nginx:1.17
```

- 重新启动服务：`docker restart cdk8s-nginx`

-------------------------------------------------------------------



## Jenkins pipeline （Docker 方式运行 tkey-sso-server）

- **确保** 项目根目录有 Dockerfile 文件
- 特别注意：

```
这两个大写的名词来自 Jenkins 全局工具配置中相应配置的 name 中填写的内容
jdk 'JDK8'
maven 'MAVEN3'
```

```
pipeline {
  agent any

  /*=======================================工具环境修改-start=======================================*/
  tools {
    jdk 'JDK8'
    maven 'MAVEN3'
  }
  /*=======================================工具环境修改-end=======================================*/

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }

  /*=======================================常修改变量-start=======================================*/

  environment {
    gitUrl = "https://github.com/cdk8s/tkey.git"
    branchName = "master"
    giteeCredentialsId = "cdk8s-github"
    projectWorkSpacePath = "${env.WORKSPACE}"
    projectBuildTargetPath = "${projectWorkSpacePath}/target"


    dockerImageName = "harbor.cdk8s.com/tkey/${env.JOB_NAME}:${env.BUILD_NUMBER}"
    dockerContainerName = "${env.JOB_NAME}"
    inHostPort = "9091"
    inHostPortByActuator = "19091"
    inDockerAndJavaPort = "9091"
    inDockerAndJavaPortByActuator = "19091"
    inHostLogPath = "/data/logs/${dockerContainerName}/${env.BUILD_NUMBER}"
    inDockerLogPath = "/logs"
    dockerRunParam = "--name=${dockerContainerName} --hostname=${dockerContainerName} -v /etc/hosts:/etc/hosts -v ${inHostLogPath}:${inDockerLogPath} --restart=always  -p ${inHostPort}:${inDockerAndJavaPort} -p ${inHostPortByActuator}:${inDockerAndJavaPortByActuator} -e SPRING_PROFILES_ACTIVE=test -e SERVER_PORT=${inHostPort} -e SPRING_REDIS_HOST=redis.cdk8s.com -e SPRING_REDIS_PASSWORD=123456 -e TKEY_NODE_NUMBER=12"
  }
  
  /*=======================================常修改变量-end=======================================*/
  
  stages {
    
    stage('Pre Env') {
      steps {
         echo "======================================项目名称 = ${env.JOB_NAME}"
         echo "======================================项目 URL = ${gitUrl}"
         echo "======================================项目分支 = ${branchName}"
         echo "======================================当前编译版本号 = ${env.BUILD_NUMBER}"
         echo "======================================项目空间文件夹路径 = ${projectWorkSpacePath}"
         echo "======================================项目 build 后 jar 路径 = ${projectBuildTargetPath}"
         echo "======================================Docker 镜像名称 = ${dockerImageName}"
         echo "======================================Docker 容器名称 = ${dockerContainerName}"
      }
    }
    
    stage('Git Clone'){
      steps {
          git branch: "${branchName}",
          credentialsId: "${giteeCredentialsId}",
          url: "${gitUrl}"
      }
    }

    stage('Maven Clean') {
      steps {
        sh "mvn clean"
      }
    }

    stage('Maven Package') {
      steps {
        sh "mvn package -DskipTests"
      }
    }

    stage('构建 Docker 镜像') {
      steps {
        sh """
            cd ${projectWorkSpacePath}
            
            docker build -t ${dockerImageName} ./
        """
      }
    }

    stage('运行 Docker 镜像') {
      steps {
        sh """
            docker stop ${dockerContainerName} | true

            docker rm -f ${dockerContainerName} | true
            
            docker run -d  ${dockerRunParam} ${dockerImageName}
        """
      }
    }


  }
}
```





## Jenkins pipeline （Docker 方式运行 tkey-sso-client-management 后端）

- **确保** 项目根目录有 Dockerfile 文件
- 特别注意：

```
这两个大写的名词来自 Jenkins 全局工具配置中相应配置的 name 中填写的内容
jdk 'JDK8'
maven 'MAVEN3'
```

```
pipeline {
  agent any

  /*=======================================工具环境修改-start=======================================*/
  tools {
    jdk 'JDK8'
    maven 'MAVEN3'
  }
  /*=======================================工具环境修改-end=======================================*/

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }

  /*=======================================常修改变量-start=======================================*/

  environment {
    gitUrl = "https://github.com/cdk8s/tkey-sso-client-management.git"
    branchName = "master"
    giteeCredentialsId = "cdk8s-github"
    projectWorkSpacePath = "${env.WORKSPACE}"
    projectBuildTargetPath = "${projectWorkSpacePath}/target"


    dockerImageName = "harbor.cdk8s.com/tkey/${env.JOB_NAME}:${env.BUILD_NUMBER}"
    dockerContainerName = "${env.JOB_NAME}"
    inHostPort = "9095"
    inHostPortByActuator = "19095"
    inDockerAndJavaPort = "9095"
    inDockerAndJavaPortByActuator = "19095"
    inHostLogPath = "/data/logs/${dockerContainerName}/${env.BUILD_NUMBER}"
    inDockerLogPath = "/logs"
    dockerRunParam = "--name=${dockerContainerName} --hostname=${dockerContainerName} -v /etc/hosts:/etc/hosts -v ${inHostLogPath}:${inDockerLogPath} --restart=always  -p ${inHostPort}:${inDockerAndJavaPort} -p ${inHostPortByActuator}:${inDockerAndJavaPortByActuator} -e SPRING_PROFILES_ACTIVE=test -e SERVER_PORT=${inHostPort} -e SPRING_REDIS_HOST=redis.cdk8s.com -e SPRING_REDIS_PASSWORD=123456"
  }
  
  /*=======================================常修改变量-end=======================================*/
  
  stages {
    
    stage('Pre Env') {
      steps {
         echo "======================================项目名称 = ${env.JOB_NAME}"
         echo "======================================项目 URL = ${gitUrl}"
         echo "======================================项目分支 = ${branchName}"
         echo "======================================当前编译版本号 = ${env.BUILD_NUMBER}"
         echo "======================================项目空间文件夹路径 = ${projectWorkSpacePath}"
         echo "======================================项目 build 后 jar 路径 = ${projectBuildTargetPath}"
         echo "======================================Docker 镜像名称 = ${dockerImageName}"
         echo "======================================Docker 容器名称 = ${dockerContainerName}"
      }
    }
    
    stage('Git Clone'){
      steps {
          git branch: "${branchName}",
          credentialsId: "${giteeCredentialsId}",
          url: "${gitUrl}"
      }
    }

    stage('Maven Clean') {
      steps {
        sh "mvn clean"
      }
    }

    stage('Maven Package') {
      steps {
        sh "mvn package -DskipTests"
      }
    }

    stage('构建 Docker 镜像') {
      steps {
        sh """
            cd ${projectWorkSpacePath}
            
            docker build -t ${dockerImageName} ./
        """
      }
    }

    stage('运行 Docker 镜像') {
      steps {
        sh """
            docker stop ${dockerContainerName} | true

            docker rm -f ${dockerContainerName} | true
            
            docker run -d  ${dockerRunParam} ${dockerImageName}
        """
      }
    }
    

  }
}
```



## Jenkins pipeline （Docker 方式运行 tkey-sso-client-management 前端）


```
pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }

  /*=======================================常修改变量-start=======================================*/

  environment {
    gitUrl = "https://github.com/cdk8s/tkey-sso-client-management-frontend.git"
    branchName = "master"
    giteeCredentialsId = "cdk8s-github"
    projectBuildPath = "${env.WORKSPACE}/dist"
    nginxHtmlRoot = "/data/docker/nginx/html/tkey-sso-client-management-frontend"
  }
  
  /*=======================================常修改变量-end=======================================*/
  
  stages {
    
    stage('Pre Env') {
      steps {
         echo "======================================项目名称 = ${env.JOB_NAME}"
         echo "======================================项目 URL = ${gitUrl}"
         echo "======================================项目分支 = ${branchName}"
         echo "======================================当前编译版本号 = ${env.BUILD_NUMBER}"
         echo "======================================项目 Build 文件夹路径 = ${projectBuildPath}"
         echo "======================================项目 Nginx 的 ROOT 路径 = ${nginxHtmlRoot}"
      }
    }
    
    stage('Git Clone'){
      steps {
          git branch: "${branchName}",
          credentialsId: "${giteeCredentialsId}",
          url: "${gitUrl}"
      }
    }

    stage('YARN Install') {
      steps {
        sh "yarn install"
      }
    }

    stage('YARN Build') {
      steps {
        sh "yarn build:test"
      }
    }

    stage('Nginx Deploy') {
      steps {
        sh "rm -rf ${nginxHtmlRoot}/"
        sh "cp -r ${projectBuildPath}/ ${nginxHtmlRoot}/"
      }
    }


  }
}
```

-------------------------------------------------------------------


## GoAccess

- GoAccess 建议用本地安装
- 安装步骤过长，请参考我们的这篇文章：[GoAccess](https://github.com/cdk8s/cdk8s-team-style/blob/master/os/linux/goaccess.md)
- 创建目录：`mkdir -p /data/docker/nginx/html/report`
- 手动运行

```
goaccess -f /data/docker/nginx/logs/access.log --geoip-database=/opt/GeoLite2-City_20190820/GeoLite2-City.mmdb -p /etc/goaccess_log_conf_nginx.conf -o /data/docker/nginx/html/report/index.html
```

- 实时运行

```
goaccess -f /data/docker/nginx/logs/access.log --geoip-database=/opt/GeoLite2-City_20190820/GeoLite2-City.mmdb -p /etc/goaccess_log_conf_nginx.conf -o /data/docker/nginx/html/report/index.html --real-time-html --daemonize
```


-------------------------------------------------------------------



## Nginx 最终配置

- 因为 nginx 在 docker 里面，所以不能用 127.0.0.1

```
配置文件：
vim /data/docker/nginx/conf/nginx.conf



worker_processes      1;

events {
  worker_connections  1024;
}

http {
  include             mime.types;
  default_type        application/octet-stream;

  charset  utf8;

  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for" "$request_time"';

  access_log /var/log/nginx/access.log main;
  error_log /var/log/nginx/error.log;


  sendfile on;
  keepalive_timeout   65;

  gzip on;
  gzip_buffers 8 16k;
  gzip_min_length 512;
  gzip_disable "MSIE [1-6]\.(?!.*SV1)";
  gzip_http_version 1.1;
  gzip_types   text/plain text/css application/javascript application/x-javascript application/json application/xml;

  server {
    listen            80;
    server_name       localhost 127.0.0.1 182.61.44.40;

    location /tkey-test {
        return 601;
    }

    location ^~ /upload {
        root    /home/root/sculptor-boot-backend-upload-dir;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }

    # 需要创建目录 /data/html/tkey-sso-client-management-frontend，里面存放 index.html 等静态文件
    location ^~ /tkey-sso-client-management-frontend/ {
        root            /data/html;
        index           index.html;
        try_files $uri /tkey-sso-client-management-frontend/index.html;
    } 
    
    location ^~ /sso-client-management/ {
        proxy_pass http://172.16.16.4:9095;
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    location ^~ /sso/ {
        proxy_pass http://172.16.16.4:9091;
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }


    location ^~ /report {
      root            /data/html;
      index           index.html index.htm;
    }

    location / {
      root            /usr/share/nginx/html;
      index           index.html index.htm;
    }
  }
}

```

## hosts 配置


```
172.16.16.4 sso.cdk8s.com
172.16.16.4 test1.cdk8s.com
172.16.16.4 test2.cdk8s.com
172.16.16.4 redis.cdk8s.com
172.16.16.4 mysql.cdk8s.com
172.16.16.4 management.cdk8s.com
172.16.16.4 tkey-sso-client-management
172.16.16.4 tkey-sso
```