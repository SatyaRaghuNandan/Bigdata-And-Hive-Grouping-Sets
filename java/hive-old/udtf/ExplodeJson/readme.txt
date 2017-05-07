javac -d . ExplodeJson.java
jar cvfm ExplodeJson.jar MANIFEST.MF com/ctrip/vac/hive/common/func/ExplodeJson.class



# create temporary function ExplodeJson as 'com.ctrip.vac.hive.common.func.ExplodeJson' USING JAR 'ExplodeJson.jar';

# show functions 'ExplodeJson.*';

# select ExplodeJson(s) as (k,v) from tmp_dhua_test_data1;

# select s,k,v from tmp_dhua_test_data1 lateral view ExplodeJson(s) b as k, v;




