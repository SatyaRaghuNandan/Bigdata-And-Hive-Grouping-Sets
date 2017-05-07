# 运行
download[hdfs:///zeus/hdfs-upload-dir/myudf.jar-20170418-094540.jar myudf.jar]

show functions 'ExplodeJson.*';

create temporary function mylower as 'com.example.hive.udf.Lower' USING JAR 'udf.jar';
create temporary function JsonToMap as 'com.example.hive.udf.JsonToMap' USING JAR 'udf.jar';
create temporary function MapToJson as 'com.example.hive.udf.MapToJson' USING JAR 'udf.jar';
create temporary function ExplodeJson as 'com.example.hive.udf.ExplodeJson' USING JAR 'udf.jar';
create temporary function ExplodeMap as 'com.example.hive.udf.ExplodeMap' USING JAR 'udf.jar';

# Lower
select s,mylower(s) as ls from (select 'Abc123' as s ) a  ;

# JsonToMap
select a,JsonToMap(a) as b from (select '{"a":2,"b":3}' as a) a;
select explode(JsonToMap(a)) as (k,v) from (select '{"a":2,"b":3}' as a) a;

# MapToJson
select MaptoJson(map('ka','va','kb','vb','kc','vc'))

# ExplodeJson
select ExplodeJson(s) as (k,v) from tmp_dhua_test_data1;
select s,k,v from tmp_dhua_test_data1 lateral view ExplodeJson(s) b as k, v;

# ExplodeMap
select explodemap(s) as (k,v) from tmp_dhua_test_data1;
select s,k,v from tmp_dhua_test_data1 lateral view explodemap(s) b as k, v;

# genericudtfcount
select genericudtfcount(s)from tmp_dhua_test_data1;

# hive语法
CREATE FUNCTION [db_name.]function_name AS class_name [USING JAR|FILE|ARCHIVE 'file_uri' [, JAR|FILE|ARCHIVE 'file_uri'] ];