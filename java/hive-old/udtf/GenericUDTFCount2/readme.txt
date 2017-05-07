javac -d . GenericUDTFCount2.java
jar cvfm GenericUDTFCount2.jar MANIFEST.MF org/apache/hadoop/hive/contrib/udtf/example/GenericUDTFCount2.class



# create temporary function GenericUDTFCount2 as 'org.apache.hadoop.hive.contrib.udtf.example.GenericUDTFCount2' USING JAR 'GenericUDTFCount2.jar';


# show functions 'GenericUDTFCount.*';
# select s,txtlower(s) as s2 from tmp_dhua_test_data1;

select genericudtfcount2(s)
from tmp_dhua_test_data1
;



