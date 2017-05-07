中位数函数
download[hdfs:///zeus/hdfs-upload-dir/GenericUDAFMedian.jar-20160926-105901.jar GenericUDAFMedian.jar]
add jar GenericUDAFMedian.jar;
create temporary function median as 'com.ctrip.hive.GenericUDF.GenericUDAFMedian';