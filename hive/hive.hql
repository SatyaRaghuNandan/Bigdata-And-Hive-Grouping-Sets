-- hive内部配置
set hive.exec.dynamic.partition.mode=nonstrict; --动态分区

set mapred.job.reuse.jvm.num.tasks = 5;
set hive.exec.parallel = true;
set hive.exec.parallel.thread.number = 10;
set hive.fetch.task.conversion=more;  --开启了Fetch任务,不使用mapreduce
set hive.optimize.sort.dynamic.partition=false;  --动态分区插入速度慢的可能原因


set hivevar:currdate=${zdt.format("yyyy-MM-dd")};
set hivevar:startdate=${zdt.addDay(-30).format("yyyy-MM-dd")}; 
set hivevar:currdate=2016-05-06;

-- 高优先级的队列
set mapreduce.job.queuename=bidiy_high;

<queue name="bidiy_high">
<minResources>204800 mb, 50 vcores</minResources>
<maxResources>819200 mb, 200 vcores</maxResources>
<maxRunningApps>10</maxRunningApps>


-- shell
startdate=$(date -d "-4 day" +"%Y-%m-%d")
enddate=$(date +"%Y-%m-%d")
echo $startdate $enddate


-- hive变量
Hive的变量,命名空间，包括hiveconf，system，env，hivevar
1. hiveconf的命名空间指的是hive-site.xml下面的配置变量值。
2. system的命名空间是系统的变量，包括JVM的运行环境。
3. env的命名空间，是指环境变量，包括Shell环境下的变量信息，如HADOOP_HOME之类的
4. hivevar 普通的变量可以使用 --define key=value 或者 --hivevar key=value ,
5. [使用${x}] hivevar，前缀是可有可无；hiveconf，system，env的，前缀则不可少,${hiveconf:x},'${hiveconf:x}',${hivevar:x} ${x} '${x}'
7. set 默认使用 hiveconf:, set -v ; set hivevar:x ; set x;

例如：hive -define a=5 -e "set hivevar:b=7; set hivevar:a;set hivevar:b;select \${a} as a,\${b} as b;"

hive -H 
hive  -f 'a.sql' 
hive -e 'select a from b'

-- 查看信息
show databases
show tables '.*'
show partitions 
desc [formatted|EXTENDED] 
explain 'sql'  -- 分析查询语句
SHOW FUNCTIONS
DESCRIBE FUNCTION function_name
DESCRIBE FUNCTION EXTENDED function_name

-- 修改表
ALTER TABLE table_name RENAME TO new_table_name;
ALTER TABLE table_name CHANGE COLUMN old_column new_column column_type;
ALTER TABLE table_name ADD COLUMNS (col_name data_type [COMMENT col_comment], ...)
ALTER TABLE table_name DROP [IF EXISTS] PARTITION partition_spec


--导出数据到文件
insert overwrite local directory './a.txt' 
row format delimited 
FIELDS TERMINATED BY '\t'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
select * from table_name

-- 创建表
use dw_groupdb;
CREATE  TABLE `pkg_push_log`(
  `projname` string COMMENT 'projname',
  `dbname` string COMMENT 'database')
COMMENT '日志'
partitioned by (`d` string COMMENT 'date')
STORED AS RCFILE;

-- 插入表
insert OVERWRITE table tablename partition (d)

-- join
inner join
left outer join


-- hadoop
hadoop fs -text /zeus/hdfs-upload-dir/traffic_diy_grp_base.sql-20160825-131218.sql
hadoop fs -copyToLocal hdfs:///zeus/hdfs-upload-dir/a.jar a.jar
hdfs:///zeus/hdfs-upload-dir/kylin_cube_call-20161128-160535.unk

-- 函数
count(xxx)
count(distinct xxx) --不会把null纳入统计范围

-- 数据变换
CASE WHEN ... THEN ... ELSE... END;
concat_ws('&',SORT_ARRAY(collect_list(concat(ftype,":",vfcont))))
convert(date,xxx) 
CAST(xxx as BIGINT)
collect_list,collect_set
get_json_object(message,'$.ServiceCode') as servicecode
split
map[]
str_to_map

explode(array(1,2,3))
explode(str_to_map("a=b&c=d&e=f",'&','=') as key,value

LATERAL VIEW explode
lateralView: LATERAL VIEW udtf(expression) tableAlias AS columnAlias (',' columnAlias)*
fromClause: FROM baseTable (lateralView)*

SELECT pageid, adid FROM pageAds LATERAL VIEW explode(adid_list) adTable AS adid;
SELECT adid, count(1) FROM pageAds LATERAL VIEW explode(adid_list) adTable AS adid GROUP BY adid;
SELECT myCol1, col2 FROM baseTable LATERAL VIEW explode(col1) myTable1 AS myCol1;

SELECT myCol1, myCol2 FROM baseTable
LATERAL VIEW explode(col1) myTable1 AS myCol1
LATERAL VIEW explode(col2) myTable2 AS myCol2;

SELECT explode(myCol) AS myNewCol FROM myTable;
SELECT explode(myMap) AS (myMapKey, myMapValue) FROM myMapTable;
SELECT posexplode(myCol) AS pos, myNewCol FROM myTable;


-- 日期时间函数
unix_timestamp()  --1486690539
unix_timestamp('2000-01-01 11:12:13') -- 
from_unixtime(unix_timestamp())  --2017-02-10 09:35:39
to_date(from_unixtime(unix_timestamp())) --2017-02-10
year(from_unixtime(unix_timestamp()))  --2017
hour(from_unixtime(unix_timestamp()))  --9
datediff('2015-08-02','2015-08-01') --1

-- 排序
Row_Number() OVER (partition by a,b,c ORDER BY ts asc) as rown

-- 正则表达式
regexp_extract
regexp_replace
regexp_extract(lower(key),'pkg_list_([a-z0-9]+)_([a-z0-9]+)',1) as filtertype
regexp_extract(lower(key),'pkg_list_([a-z0-9]+)_([a-z0-9]+)',2) as sourcetype

1，替换中括号为小括号；
select regexp_replace('{"DD_出发日期":["[a,b,c]_11月","[c,d]_2016年01月"],"a":"b"}','\\[([^\\[\\]]+)\\]','($1)') as a;

2，替换中括号中的，为&
-- (?<=pattern) 非获取匹配，反向肯定预查不能为变长
select regexp_replace('{"DD_出发日期":["[a,b]_11月","[c,d]_2016年01月"],"a":"b"}',"(?<=\\[[^\\[\\]]{1,100}),(?=[^\\[\\]]+?\\])","&") as a;
select regexp_replace('{"DD_出发日期":["[a,b,c]_11月","[c,d]_2016年01月"],"a":"b"}',"(\\[[^\\[\\]]+),(?=[^\\[\\]]+?\\])","$1&") as a;
select regexp_replace('{"DD_出发日期":["[a,b,c]_11月","[c,d]_2016年01月"],"a":"b"}',",(?=[^\\[\\]]+?\\])","&") as a;


3, 替换[,]为[&],替换内层[]为<>，替换[,]为[&],替换<>为[]
select regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace('{"DD_出发日期":["[a,b]_11月","[c,d]_2016年01月"],"a":"b"}'
    ,"(?<=\\[[^\\[\\]]{1,100}),(?=[^\\[\\]]+?\\])","&")
    ,'\\[([^\\[\\]]+)\\]','<$1>')
    ,"(?<=\\[[^\\[\\]]{1,100}),(?=[^\\[\\]]+?\\])","&")
    ,"<","\\[")
    ,">","\\]") as a
;

!!!!注python引用组为\1,但是hive引用使用$1

匹配中文字符的正则表达式： [\u4e00-\u9fa5] 
匹配Email地址的正则表达式：\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)* 
匹配网址URL的正则表达式：[a-zA-z]+://[^\s]* 
匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$ 
匹配国内电话号码：\d{3}-\d{8}|\d{4}-\d{7} 
匹配中国邮政编码：[1-9]\d{5}(?!\d) 
匹配身份证 \d{15}|\d{18} 
匹配ip地址 \d+\.\d+\.\d+\.\d+ 
匹配由数字、26个英文字母或者下划线组成的字符串 ^\w+$



