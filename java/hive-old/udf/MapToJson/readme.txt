javac -d . MapToJson.java
jar cvfm MapToJson.jar MANIFEST.MF com/ctrip/vac/hive/common/func/MapToJson.class



# download[hdfs:///zeus/hdfs-upload-dir/MapToJson.jar-20161008-110935.jar MapToJson.jar]
# create temporary function MapToJson as 'com.ctrip.vac.hive.common.func.MapToJson' USING JAR 'MapToJson.jar';

# select MaptoJson(map('ka','va','kb','vb','kc','vc'))









