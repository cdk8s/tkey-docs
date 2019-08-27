#!/bin/bash

# 记得给 sh 增加执行权限：chmod +x jar.sh
pid=0
ENV=test
LOG_DATE=`date +%Y%m%d%H%M%S`
APP_NAME=tkey-sso-server
JAR_NAME=tkey-sso-server-1.0.0.jar
APP_PATH=/data/jar/$APP_NAME
APP_LOG_PATH=/data/jar/$APP_NAME/logs

DUMP_PATH=$APP_PATH/headDump
LOG_PATH=$APP_LOG_PATH/$APP_NAME.out
JAR_FILE=$APP_PATH/$JAR_NAME

APP_ENVIRONMENT="--SPRING_PROFILES_ACTIVE=$ENV --SERVER_PORT=9091 --SPRING_REDIS_HOST=redis.cdk8s.com --SPRING_REDIS_PASSWORD=123456 --TKEY_NODE_NUMBER=20"

# JVM 参数
JAVA_OPTS="$APP_ENVIRONMENT -Xms1024m -Xmx1024m -XX:MetaspaceSize=124m -XX:MaxMetaspaceSize=224m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$DUMP_PATH"

# 支持远程 debug
#JAVA_OPTS="$APP_ENVIRONMENT -Xms1024m -Xmx1024m -XX:MetaspaceSize=124m -XX:MaxMetaspaceSize=224m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$DUMP_PATH -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"


if [ ! -d $APP_LOG_PATH ]; then
	mkdir -p $APP_LOG_PATH
fi


start(){
  getpid
  if [ ! -n "$pid" ]; then
    nohup java -jar $JAR_FILE $JAVA_OPTS > $LOG_PATH 2>&1 &
    echo "----------------------------"
    echo "Application Startup Success"
    echo "----------------------------"
    sleep 2s
    tail -f $LOG_PATH
  else
      echo "$APP_NAME is runing PID: $pid"
  fi

}

status(){
   getpid
   if [ ! -n "$pid" ]; then
     echo "$APP_NAME not runing"
   else
     echo "$APP_NAME runing PID: $pid"
   fi
}

stop(){
    getpid
    if [ ! -n "$pid" ]; then
     echo "$APP_NAME not runing"
    else
      echo "$APP_NAME stop"
      kill -9 $pid
    fi
}

restart(){
    stop
    sleep 2s
    start
}

getpid(){
    pid=`ps -ef |grep $JAR_FILE |grep -v grep |awk '{print $2}'`
}

case $1 in
          start) start;;
          stop)  stop;;
          restart)  restart;;
          status)  status;;
              *)  echo "shell parameter: start|stop|restart|status"  ;;
esac
