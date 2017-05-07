javac -d . Lower.java
jar cvfm Lower.jar MANIFEST.MF com/example/hive/udf/Lower.class



# hive流程
# add jar Lower.jar;
# list jars;
# create temporary function txtlower as 'com.example.hive.udf.Lower';

# OR

# create temporary function txtlower as 'com.example.hive.udf.Lower' USING JAR 'Lower.jar';


# show functions 'txt.*';
# select s,txtlower(s) as s2 from tmp_dhua_test_data1;

