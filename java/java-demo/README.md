# 命令行编译/执行
javac -d . App.java

jar cvfm App.jar MANIFEST.MF com/example/demo/App.class

java -jar App.jar

# MANIFEST.MF
```
Manifest-Version: 1.0
Main-Class: com.example.demo.App

```
(末行必须要换行,否则找不到Main-Class)

# eclipse模板相关命令说明
* ctrl＋ shift ＋ f 		格式化
* ctrl+/				添加//注释
* ctrl+shinf+/ 		添加block注释
* ctrl+shinf+\ 		去掉block注释 


# eclipse导出jar
项目右键 -> Export...->JAR File

# maven
http://maven.apache.org/

mavon私服搭建 : https://www.sonatype.com/  之下的  Nexus Repository OSS
 
http://blog.csdn.net/u012152619/article/details/51510757



# eclipse
preferences-general-workspace: 编码-utf8，换行-uninx

# play框架的utf-8
安装目录下找到
C:\Program Files\play-1.2.3\framework\pym\play 目录下的application.py
修改245行中的java_args.append('-Dfile.encoding=utf-8')为 java_args.append('-Dfile.encoding=GBK')

