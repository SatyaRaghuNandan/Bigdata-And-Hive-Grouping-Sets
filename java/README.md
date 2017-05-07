# 说明
Java SE=Java Standard Edition SE主要用于桌面程序,控制台开发(JFC)
Java EE=Java Enterprise Edition EE企业级开发(JSP,EJB) 一般是开发Web应用
Java ME=Java Mobile Edition ME嵌入式开发(手机,小家电)

# install
http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
wget jdk-8uversion-linux-x64.tar.gz
tar zxvf jdk-8uversion-linux-x64.tar.gz

3)配置路径
export JAVA_HOME=/usr/local/java/jdk1.8.0_101
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JRE_HOME/lib
export PATH=$PATH:$JAVA_HOME/bin

# maven
http://maven.apache.org/
mavon私服搭建 : https://www.sonatype.com/  之下的  Nexus Repository OSS

# eclipse

模板相关命令说明
* ctrl＋ shift ＋ f 		格式化
* ctrl+/				添加//注释
* ctrl+shinf+/ 		添加block注释
* ctrl+shinf+\ 		去掉block注释 

项目右键 -> Export...->JAR File
preferences-general-workspace: 编码-utf8，换行-uninx

# 命令行编译打包

1,一般流程:
javac HelloWorld.java # 编译
java HelloWorld #运行class文件
jar cvfe HelloWorld.jar HelloWorld HelloWorld.class #打包,e指定应用程序入口
jar cvfm App.jar MANIFEST.MF com/example/demo/App.class
java -jar HelloWorld.jar # 运行jar文件

2,带路径
src 放置.java
bin 放置.class

javac -d bin src/HelloWorld.java
java -cp bin HelloWorld
jar cvfe bin/HelloWorld.jar HelloWorld -C bin HelloWorld.class
java -jar bin/HelloWorld.jar

3,带路径以及package:app/HelloWorld.java

javac -d bin src/app/HelloWorld.java
java -cp bin app/HelloWorld
jar cvfe bin/appHelloWorld.jar app/HelloWorld -C bin app/HelloWorld.class #打包,e指定应用程序入口
java -jar bin/appHelloWorld.jar
jar cvfm bin/appHelloWorld-mf.jar src/app/MANIFEST.MF -C bin app/HelloWorld.class #打包,m指定.mf文件
java -jar bin/appHelloWorld-mf.jar

# MANIFEST.MF
```
Manifest-Version: 1.0
Main-Class: com.example.demo.App

```
(末行必须要换行,否则找不到Main-Class)


# play框架的utf-8
安装目录下找到
C:\Program Files\play-1.2.3\framework\pym\play 目录下的application.py
修改245行中的java_args.append('-Dfile.encoding=utf-8')为 java_args.append('-Dfile.encoding=GBK')