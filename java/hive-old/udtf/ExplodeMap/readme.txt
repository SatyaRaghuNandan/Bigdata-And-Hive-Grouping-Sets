javac -d . ExplodeMap.java
jar cvfm ExplodeMap.jar MANIFEST.MF org/apache/hadoop/hive/contrib/udtf/example/ExplodeMap.class



# create temporary function ExplodeMap as 'org.apache.hadoop.hive.contrib.udtf.example.ExplodeMap' USING JAR 'ExplodeMap.jar';

# show functions 'explodemap.*';

# select explodemap(s) as (k,v) from tmp_dhua_test_data1;

# select s,k,v from tmp_dhua_test_data1 lateral view explodemap(s) b as k, v;




