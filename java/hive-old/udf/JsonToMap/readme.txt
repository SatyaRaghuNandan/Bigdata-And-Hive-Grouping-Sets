javac -d . JsonToMap.java
jar cvfm JsonToMap.jar MANIFEST.MF com/ctrip/vac/hive/common/func/JsonToMap.class




# create temporary function JsonToMap as 'com.ctrip.vac.hive.common.func.JsonToMap' USING JAR 'JsonToMap.jar';

# select a,JsonToMap(a) as b from (select '{"a":2,"b":["abc","b"]}' as a) a;
# select explode(jsontomap(s)) as (k,v) from tmp_dhua_test_data1;






