
hdfs dfs -ls hdfs://ns/user/biuser/warehouse/etl/Tmp_SBU_PkgQueryDB.db/dhua


-- Hive CLI
hive -H 

!ls;!pwd;!cat data.txt; -- hive内部运行linux命令 +!


set mapred.job.reuse.jvm.num.tasks = 5;
set hive.exec.parallel = true;
set hive.exec.parallel.thread.number = 10;
set hive.fetch.task.conversion=more;  --开启了Fetch任务,不使用mapreduce

-- 
ALTER TABLE table_name RENAME TO new_table_name;
ALTER TABLE table_name [PARTITION partition_spec] CHANGE [COLUMN] col_old_name col_new_name column_type
ALTER TABLE tmp_dhua_list_tracelog_base_ext_theme CHANGE COLUMN pkgnum resultnum int;
ALTER TABLE table_name ADD COLUMNS (col_name data_type [COMMENT col_comment], ...)
ALTER TABLE table_name DROP [IF EXISTS] PARTITION partition_spec
ALTER TABLE page_view DROP PARTITION (dt='2008-08-08', country='us');




-- hive变量
Hive的变量,命名空间，包括hiveconf，system，env，hivevar
1. hiveconf的命名空间指的是hive-site.xml下面的配置变量值。
2. system的命名空间是系统的变量，包括JVM的运行环境。
3. env的命名空间，是指环境变量，包括Shell环境下的变量信息，如HADOOP_HOME之类的
4. hivevar 普通的变量可以使用 --define key=value 或者 --hivevar key=value ,
5. [使用${x}] hivevar，前缀是可有可无；hiveconf，system，env的，前缀则不可少,${hiveconf:x},'${hiveconf:x}',${hivevar:x} ${x} '${x}'
7. set 默认使用 hiveconf:, set -v ; set hivevar:x ; set x;
例如：hive -define a=5 -e "set hivevar:b=7; set hivevar:a;set hivevar:b;select \${a} as a,\${b} as b;"

set hivevar:currday=2015-09-08;
set hivevar:yestaday=2015-09-07;
set hivevar:yestaweek=2015-09-01;
set hivevar:yestamonth=2015-08-08;

set hivevar:deposit_transaction_time=${yestaday};
set hivevar:bid_time=${yestaweek};
set hivevar:start_flow=${yestaday};
set hivevar:end_flow=${currday};
set hivevar:start_order=${yestamonth};
set hivevar:end_order=${currday};

select "${deposit_transaction_time}" as deposit_transaction_time,"${bid_time}" as bid_time
,"${start_flow}" as start_flow,"${end_flow}" as end_flow
,"${start_order}" as start_order,"${end_order}" as end_order
;


hive  -f 'a.sql' > a.txt
hive -e ''
tar zcvf a.tar.gz a.txt

-- 准备数据文件
echo -en '1\t2.0\ta' >data.txt
echo -en '\n1\t2.0\tb' >>data.txt



-- 查看

-- 正则表达式
regexp_extract
regexp_replace
regexp = rlike 'ctm_tour_grouptravel_(filter|line|time|sortby|go).*' 
select 'a123b' rlike '12' as a ,'b123a34b' rlike '[123]+a(12|34)' as b ; 

select REGEXP_EXTRACT('HasSoonGroup:true','(Group:)') as c1
,REGEXP_EXTRACT('HasSoonGroup:true','(Group:)',1) as c2
,REGEXP_EXTRACT('HasSoonGroup:true','(Group:[turefals]+)',1) as c3
;



替换中括号中的逗号: 注意{1,100}代替+
regexp_replace(filter,"(?<=\\[[^\\[\\]]{1,100}),(?=[^\\[\\]]+?\\])","&")

select regexp_replace('{"a_包含区域":["139_澳门","138_香港"],"d_途经景区":["39_澳门","38_香港"],"l_游玩线路":["173_香港+澳门"],"dc_出发城市":["2_上海"]}'
    ,"(?<=\\[[^\\[\\]]{1,100}),(?=[^\\[\\]]+?\\])","&");


select split('{a_包含区域:[139_澳门,138_香港,台湾],d_途经景区:[39_澳门,38_香港],dc_出发城市:[2_上海]}'
    ,'(?<!\\[[^\\[\\]]{1,50}),(?![^\\[\\]]+?\\])');



select a.*,b.f 
from (
select *
, regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(filter
    ,",(?=[^\\[\\]]+?\\])","&")
    ,'\\[([^\\[\\]]+)\\]','<$1>')
    ,",(?=[^\\[\\]]+?\\])","&")
    ,"<","\\[")
    ,">","\\]")as filter2
from tmp_dhua_list_tracelog_filter_group_1) a
LATERAL VIEW explode(split(regexp_replace(regexp_extract(filter2,'^\\{(.*)\\}$',1),'"',''),',')) b as f
;


select regexp_extract('[2016-07-01,2016-07-31]_7月','[^_]+_(?=2016年)?[0]?(.*)',1) as a
,regexp_extract('[2016-07-01,2016-07-31]_清明节','[^_]+_(?=2016年)?[0]?(.*)',1) as b
,regexp_extract('201606_2016年6月','[^_]+_(?:2016年)?[0]?(.*)',1) as c
;


-- 字符串操作

========================================================================================
Hive分析窗口函数(一) SUM,AVG,MIN,MAX

-- 分组排序
create table tmp_dhua_test_windowsfunc(
id string,
dt string,
value int
);

insert OVERWRITE table tmp_dhua_test_windowsfunc
select split(a,',')[0],split(a,',')[1],split(a,',')[2]
from (
select explode(array('a,2015-01-01,1','a,2015-01-02,1','a,2015-01-03,2'
  ,'b,2015-01-01,1','b,2015-01-01,2','b,2015-01-02,3'
  ,'c,2015-01-01,1','c,2015-01-02,2','c,2015-01-03,3'))  as a) a


SELECT cookieid,
createtime,
pv,
SUM(pv) OVER(PARTITION BY cookieid ORDER BY createtime) AS pv1, -- 默认为从起点到当前行
SUM(pv) OVER(PARTITION BY cookieid ORDER BY createtime ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pv2, --从起点到当前行，结果同pv1 
SUM(pv) OVER(PARTITION BY cookieid) AS pv3,               --分组内所有行
SUM(pv) OVER(PARTITION BY cookieid ORDER BY createtime ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS pv4,   --当前行+往前3行
SUM(pv) OVER(PARTITION BY cookieid ORDER BY createtime ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING) AS pv5,    --当前行+往前3行+往后1行
SUM(pv) OVER(PARTITION BY cookieid ORDER BY createtime ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS pv6   ---当前行+往后所有行  
FROM lxw1234;

pv1: 分组内从起点到当前行的pv累积，如，11号的pv1=10号的pv+11号的pv, 12号=10号+11号+12号
pv2: 同pv1
pv3: 分组内(cookie1)所有的pv累加
pv4: 分组内当前行+往前3行，如，11号=10号+11号， 12号=10号+11号+12号， 13号=10号+11号+12号+13号， 14号=11号+12号+13号+14号
pv5: 分组内当前行+往前3行+往后1行，如，14号=11号+12号+13号+14号+15号=5+7+3+2+4=21
pv6: 分组内当前行+往后所有行，如，13号=13号+14号+15号+16号=3+2+4+4=13，14号=14号+15号+16号=2+4+4=10

 

如果不指定ROWS BETWEEN,默认为从起点到当前行;
如果不指定ORDER BY，则将分组内所有值累加;
关键是理解ROWS BETWEEN含义,也叫做WINDOW子句：
PRECEDING：往前
FOLLOWING：往后
CURRENT ROW：当前行
UNBOUNDED：起点，UNBOUNDED PRECEDING 表示从前面的起点， UNBOUNDED FOLLOWING：表示到后面的终点

–其他AVG，MIN，MAX，和SUM用法一样。


----------------------------------------------------------------------
Hive分析窗口函数(二) 序列函数，NTILE,ROW_NUMBER,RANK,DENSE_RANK

NTILE(n)，用于将分组数据按照顺序切分成n片，返回当前切片值
NTILE不支持ROWS BETWEEN，比如 NTILE(2) OVER(PARTITION BY cookieid ORDER BY createtime ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)
如果切片不均匀，默认增加第一个切片的分布

SELECT 
cookieid,
createtime,
pv,
NTILE(2) OVER(PARTITION BY cookieid ORDER BY createtime) AS rn1,  --分组内将数据分成2片
NTILE(3) OVER(PARTITION BY cookieid ORDER BY createtime) AS rn2,  --分组内将数据分成3片
NTILE(4) OVER(ORDER BY createtime) AS rn3        --将所有数据分成4片
FROM lxw1234 
ORDER BY cookieid,createtime;



ROW_NUMBER() –从1开始，按照顺序，生成分组内记录的序列
–比如，按照pv降序排列，生成分组内每天的pv名次
ROW_NUMBER() 的应用场景非常多，再比如，获取分组内排序第一的记录;获取一个session中的第一条refer等。

SELECT 
cookieid,
createtime,
pv,
ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY pv desc) AS rn 
FROM lxw1234;

—RANK() 生成数据项在分组中的排名，排名相等会在名次中留下空位
—DENSE_RANK() 生成数据项在分组中的排名，排名相等会在名次中不会留下空位

SELECT 
cookieid,
createtime,
pv,
RANK() OVER(PARTITION BY cookieid ORDER BY pv desc) AS rn1,
DENSE_RANK() OVER(PARTITION BY cookieid ORDER BY pv desc) AS rn2,
ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY pv DESC) AS rn3 
FROM lxw1234 
WHERE cookieid = 'cookie1';

–CUME_DIST 小于等于当前值的行数/分组内总行数
–比如，统计小于等于当前薪水的人数，所占总人数的比例

SELECT 
dept,
userid,
sal,
CUME_DIST() OVER(ORDER BY sal) AS rn1,
CUME_DIST() OVER(PARTITION BY dept ORDER BY sal) AS rn2 
FROM lxw1234;

–PERCENT_RANK 分组内当前行的RANK值-1/分组内总行数-1
应用场景不了解，可能在一些特殊算法的实现中可以用到吧。

SELECT 
dept,
userid,
sal,
PERCENT_RANK() OVER(ORDER BY sal) AS rn1,   --分组内
RANK() OVER(ORDER BY sal) AS rn11,          --分组内RANK值
SUM(1) OVER(PARTITION BY NULL) AS rn12,     --分组内总行数
PERCENT_RANK() OVER(PARTITION BY dept ORDER BY sal) AS rn2 
FROM lxw1234;


LAG(col,n,DEFAULT) 用于统计窗口内往上第n行值
第一个参数为列名，第二个参数为往上第n行（可选，默认为1），第三个参数为默认值（当往上第n行为NULL时候，取默认值，如不指定，则为NULL）

SELECT cookieid,
createtime,
url,
ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY createtime) AS rn,
LAG(createtime,1,'1970-01-01 00:00:00') OVER(PARTITION BY cookieid ORDER BY createtime) AS last_1_time,
LAG(createtime,2) OVER(PARTITION BY cookieid ORDER BY createtime) AS last_2_time 
FROM lxw1234;

与LAG相反
LEAD(col,n,DEFAULT) 用于统计窗口内往下第n行值
第一个参数为列名，第二个参数为往下第n行（可选，默认为1），第三个参数为默认值（当往下第n行为NULL时候，取默认值，如不指定，则为NULL）

SELECT cookieid,
createtime,
url,
ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY createtime) AS rn,
LEAD(createtime,1,'1970-01-01 00:00:00') OVER(PARTITION BY cookieid ORDER BY createtime) AS next_1_time,
LEAD(createtime,2) OVER(PARTITION BY cookieid ORDER BY createtime) AS next_2_time 
FROM lxw1234;

FIRST_VALUE

取分组内排序后，截止到当前行，第一个值

SELECT cookieid,
createtime,
url,
ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY createtime) AS rn,
FIRST_VALUE(url) OVER(PARTITION BY cookieid ORDER BY createtime) AS first1 
FROM lxw1234;

LAST_VALUE

取分组内排序后，截止到当前行，最后一个值

SELECT cookieid,
createtime,
url,
ROW_NUMBER() OVER(PARTITION BY cookieid ORDER BY createtime) AS rn,
LAST_VALUE(url) OVER(PARTITION BY cookieid ORDER BY createtime) AS last1 
FROM lxw1234;

GROUPING SETS,GROUPING__ID,CUBE,ROLLUP

这几个分析函数通常用于OLAP中，不能累加，而且需要根据不同维度上钻和下钻的指标统计，比如，分小时、天、月的UV数。

GROUPING SETS

在一个GROUP BY查询中，根据不同的维度组合进行聚合，等价于将不同维度的GROUP BY结果集进行UNION ALL

SELECT 
month,
day,
COUNT(DISTINCT cookieid) AS uv,
GROUPING__ID 
FROM lxw1234 
GROUP BY month,day 
GROUPING SETS (month,day) 
ORDER BY GROUPING__ID;


等价于 
SELECT month,NULL,COUNT(DISTINCT cookieid) AS uv,1 AS GROUPING__ID FROM lxw1234 GROUP BY month 
UNION ALL 
SELECT NULL,day,COUNT(DISTINCT cookieid) AS uv,2 AS GROUPING__ID FROM lxw1234 GROUP BY day
再如：

SELECT 
month,
day,
COUNT(DISTINCT cookieid) AS uv,
GROUPING__ID 
FROM lxw1234 
GROUP BY month,day 
GROUPING SETS (month,day,(month,day)) 
ORDER BY GROUPING__ID;

等价于
SELECT month,NULL,COUNT(DISTINCT cookieid) AS uv,1 AS GROUPING__ID FROM lxw1234 GROUP BY month 
UNION ALL 
SELECT NULL,day,COUNT(DISTINCT cookieid) AS uv,2 AS GROUPING__ID FROM lxw1234 GROUP BY day
UNION ALL 
SELECT month,day,COUNT(DISTINCT cookieid) AS uv,3 AS GROUPING__ID FROM lxw1234 GROUP BY month,day
其中的 GROUPING__ID，表示结果属于哪一个分组集合。

 

 

CUBE

根据GROUP BY的维度的所有组合进行聚合。

SELECT 
month,
day,
COUNT(DISTINCT cookieid) AS uv,
GROUPING__ID 
FROM lxw1234 
GROUP BY month,day 
WITH CUBE 
ORDER BY GROUPING__ID;

等价于
SELECT NULL,NULL,COUNT(DISTINCT cookieid) AS uv,0 AS GROUPING__ID FROM lxw1234
UNION ALL 
SELECT month,NULL,COUNT(DISTINCT cookieid) AS uv,1 AS GROUPING__ID FROM lxw1234 GROUP BY month 
UNION ALL 
SELECT NULL,day,COUNT(DISTINCT cookieid) AS uv,2 AS GROUPING__ID FROM lxw1234 GROUP BY day
UNION ALL 
SELECT month,day,COUNT(DISTINCT cookieid) AS uv,3 AS GROUPING__ID FROM lxw1234 GROUP BY month,day
 

ROLLUP

是CUBE的子集，以最左侧的维度为主，从该维度进行层级聚合。

比如，以month维度进行层级聚合：
SELECT 
month,
day,
COUNT(DISTINCT cookieid) AS uv,
GROUPING__ID  
FROM lxw1234 
GROUP BY month,day
WITH ROLLUP 
ORDER BY GROUPING__ID;

可以实现这样的上钻过程：
月天的UV->月的UV->总UV
--把month和day调换顺序，则以day维度进行层级聚合：
 
SELECT 
day,
month,
COUNT(DISTINCT cookieid) AS uv,
GROUPING__ID  
FROM lxw1234 
GROUP BY day,month 
WITH ROLLUP 
ORDER BY GROUPING__ID;

可以实现这样的上钻过程：
天月的UV->天的UV->总UV
（这里，根据天和月进行聚合，和根据天聚合结果一样，因为有父子关系，如果是其他维度组合的话，就会不一样）
这种函数，需要结合实际场景和数据去使用和研究，只看说明的话，很难理解。

官网的介绍： https://cwiki.apache.org/confluence/display/Hive/Enhanced+Aggregation%2C+Cube%2C+Grouping+and+Rollup





========================================================================================






--数据库信息
show databases;
use db;


--表信息
show tables 'dhua.*';
desc [formatted|EXTENDED]db.tb;
show partitions db.tb;
-- 分析查询语句 
explain 'sql'

--函数
SHOW FUNCTIONS;
DESCRIBE FUNCTION <function_name>;
DESCRIBE FUNCTION EXTENDED <function_name>;

-- 用户自定义函数 UDF,UDAF,UDTF
-- UDF操作作用于单个数据行，且产生一个数据行输出； 
-- UDAF接收多个输入数据行，产生一个数据行输出； 
-- UDTF接收单个数据行，产生多个数据行（一个表）作为输出。


-- 日期时间函数
select unix_timestamp() as ut
,from_unixtime(unix_timestamp()) as sut
,to_date(from_unixtime(unix_timestamp())) as sdate
,year(from_unixtime(unix_timestamp())) as year
,hour(from_unixtime(unix_timestamp())) as hour
;


-- 插入当天日期
set hive.exec.dynamic.partition.mode=nonstrict; 
insert OVERWRITE table dhua_biddetail_insertd partition (insertd)
select * ,to_date(from_unixtime(unix_timestamp(),'yyyy-MM-dd')) as insertd
from dhua_biddetail
;

-- 函数
select count(distinct null) as c;
,count(distinct case when pageid_detail is not null then vid else NULL end) as uv2


to_date(a.creationdate) rlike '2014-06-0[1-7]'
convert(date,Insertdt) as errday

unix_timestamp(a.creationdate)>=unix_timestamp('2014-06-01 00:00:00') 
and unix_timestamp(a.creationdate)<unix_timestamp('2014-06-08 00:00:00')

select '1438403870608' as ts
,from_unixtime(cast(substr('1438403870608',1,10) as BIGINT)) as ts2
,substr(from_unixtime(cast(substr('1438403870608',1,10) as BIGINT)),1,10) as ts3
;

select datediff('2015-08-02','2015-08-01'); --1






-- 结构分析函数



get_json_object(message,'$.ServiceCode') as servicecode
split

select get_json_object('{"departcityid":"2","tab":"出发地参团",
"kwd":["美国","D","01"],"filter":{"ADHB_酒店品牌":"182_希尔顿","ADPR_特色项目":"550_博物馆"}}','$.filter') as a
,get_json_object('{"departcityid":"2","tab":"出发地参团",
"kwd":["美国","D","01"],"filter":{"ADHB_酒店品牌":"182_希尔顿","ADPR_特色项目":"550_博物馆"}}','$.kwd[1]') as b
;

select get_json_object( '{"salescityid":"2","kwd":["三亚","D","61"],"filter":{"L_游玩线路":["918_华东+其他","1_马尔代夫一地"
  ,"13_雅加达+巴厘岛"],"N_产品类型":"1_跟团游","G_产品等级":"4_4钻"
  ,"departdate":["2015-9-26","2015-9-30"],"price":["1000","1500"]},"pkgnum":"20"}','$.kwd[1]') as b


select get_json_object( '{"salescityid":"2","kwd":["三亚","D","61"],"filter":{"L_游玩线路":["918_华东+其他","1_马尔代夫一地"
  ,"13_雅加达+巴厘岛"],"N_产品类型":"1_跟团游","G_产品等级":"4_4钻"
  ,"departdate":["2015-9-26","2015-9-30"],"price":["1000","1500"]},"pkgnum":"20"}','$.filter') as b

-- NULL与''的区别
a='' 那么 a is null==false;  a ='' ==true
如果根据 is not null ,那么TRUE; 如果根据 not in ('') ,那么FALSE;


--导出数据到文件
insert overwrite local directory './a.txt' 
row format delimited 
FIELDS TERMINATED BY '\t'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
select * from ods_pkgproductdb.PkgProvider;

weekday_mapper.py 
------------------------
import sys
import datetime
 
for line in sys.stdin:
  line = line.strip()
  userid, unixtime = line.split('\t')
  weekday = datetime.datetime.fromtimestamp(float(unixtime)).isoweekday()
  print ','.join([userid, str(weekday)])
-------------------------

import sys
import re
for line in sys.stdin:
    line = line.strip()
    pattern=r',([\w\x80-\xff]+):'
    print re.sub(pattern,r'&\1:',line)

add FILE /home/sbupkg/dhua/python/myre.py;
list FILES;
select TRANSFORM('asdf&bcc:cde,asdlfjk,b_中文:asdf')  using 'python myre.py' as  a;


line='(u_游玩天数:(4_4日,4_4日),departureDate:([2015-08-02,2015-08-04]),price:(500,1000))'
print

regexp_replace(str_to_map(value,'&','=')['filter'],'^\\(|\\)$','')


1，替换中括号为小括号；
select regexp_replace('{"DD_出发日期":["[a,b,c]_11月","[c,d]_2016年01月"],"a":"b"}','\\[([^\\[\\]]+)\\]','($1)') as a;

2，替换中括号中的，为&
-- (?<=pattern) 非获取匹配，反向肯定预查不能为变长
select regexp_replace('{"DD_出发日期":["[a,b]_11月","[c,d]_2016年01月"],"a":"b"}',"(?<=\\[[^\\[\\]]{1,100}),(?=[^\\[\\]]+?\\])","&") as a;
select regexp_replace('{"DD_出发日期":["[a,b,c]_11月","[c,d]_2016年01月"],"a":"b"}',"(\\[[^\\[\\]]+),(?=[^\\[\\]]+?\\])","$1&") as a;
select regexp_replace('{"DD_出发日期":["[a,b,c]_11月","[c,d]_2016年01月"],"a":"b"}',",(?=[^\\[\\]]+?\\])","&") as a;


{"DD_出发日期":["[a&b]_11月","[c&d]_2016年01月"],"a":"b"}
{"DD_出发日期":["[a&b]_11月","[c&d]_2016年01月"],"a":"b"}


3, 替换[,]为[&],替换内层[]为<>，替换[,]为[&],替换<>为[]
select regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace('{"DD_出发日期":["[a,b]_11月","[c,d]_2016年01月"],"a":"b"}'
    ,"(?<=\\[[^\\[\\]]{1,100}),(?=[^\\[\\]]+?\\])","&")
    ,'\\[([^\\[\\]]+)\\]','<$1>')
    ,"(?<=\\[[^\\[\\]]{1,100}),(?=[^\\[\\]]+?\\])","&")
    ,"<","\\[")
    ,">","\\]") as a
;


!!!!注python引用组为\1,但是hive引用使用$1
select regexp_replace('(u_游玩天数:(4_4日,4_4日),departureDate:([2015-08-02,2015-08-04]),price:(500,1000))','[^\\(\\)$]') as a

select regexp_replace('(u_游玩天数:(4_4日,4_4日),departureDate:([2015-08-02,2015-08-04]),price:(500,1000))','^\\(|\\)$','') as a;

select regexp_replace('(u_游玩天数:(4_4日,4_4日),departureDate:([2015-08-02,2015-08-04]),price:(500,1000))',',([\w\x80-\xff]+):','&\1:') as a;

select regexp_replace('(u_游玩天数:(4_4日,4_4日),departureDate:([2015-08-02,2015-08-04]),price中:(500,1000))',',([\\w\\x80-\\xff]+):','&\\1:') as a;

select regexp_replace('(u_游玩天数:(4_4日,4_4日),departureDate:([2015-08-02,2015-08-04]),price中:(500,1000))',',(\\w+):','&\$1:') as a;

select regexp_replace('(u_游玩天数:(4_4日,4_4日),departureDate:([2015-08-02,2015-08-04]),price中:(500,1000))',',([\\w\\x80-\\xff]+):','&\$1:') as a;

select regexp_replace('(u_游玩天数:(4_4日,4_4日),departureDate:([2015-08-02,2015-08-04]),price中:(500,1000))',',([\\w\\u4e00-\\u9fa5]+):','&\$1:') as a;


select regexp_replace(value,',([\\w\\u4e00-\\u9fa5]+):','&\$1:') as a;


regexp_extract(value,"\\\"TAG_服务标签\\\"\\:\\[([^\\]]+)\\]",1) as tagfilter

-------------------------------------------

hive 匹配中文 rlike '^[\\u4e00-\\u9fa5]+$';


pattern=r',([\w\u4e00-\u9fa5]+):'
line='asdf&bcc:cde,asdlfjk,b:asdf'
line2='asdf&bcc:cde,asdlfjk,b_中文:asdf'
re.sub(pattern,r'&\1:',line)


cat 'asdf,bcc:cde,asdlfjk,b_中文:asdf' | python myre.py



SELECT TRANSFORM(pv_users.userid, pv_users.date) USING 'map_script' AS dt, uid CLUSTER BY dt FROM pv_users;

----

-- Map Reduce脚本
show functions;
desc function 


使用Hadoop Streaming, TRANSFORM, MAP, REDUCE子句这样的方法，便可以在Hive中调用外部脚本。
Add File /path/to/is_good_quality.py;   // 将过滤程序加载到分布式缓存中

CREATE TABLE u_data_new (
userid INT,
movieid INT,
rating INT,
weekday INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t';

-- 将python文件加载到系统
add FILE weekday_mapper.py;
-- 将数据按周进行分割
INSERT OVERWRITE TABLE u_data_new
SELECT
TRANSFORM (userid, movieid, rating, unixtime)
USING 'python weekday_mapper.py'
AS (userid, movieid, rating, weekday)
FROM u_data;


-- 如果要用查询的嵌套形式，我们可以指定map和reduce函数。

From (
   From record2
   Map year, temperature, quality
   Using ‘is_good_quality.py’
   As year, temperature ) map_output
Reduce year, temperature
Using ‘max_temperature_reduce.py’
As year, temperature;


#用python编写用于查找最高气温的reduce函数
cat sample.txt | max_temperature_map.py | sort | 

UDAF
-----------------
collect_list,collect_set
create table dhua_test_001(a string,b string) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
-- vi dhua_test_001.txt
-- a	a1
-- b	b1
-- c	c1
-- a	a2
-- b	b2
-- a	a3
LOAD DATA 
LOCAL INPATH '/home/sbupkg/dhua/dhua_test_001.txt' 
OVERWRITE INTO 
TABLE dhua_test_001;

create table dhua_test_002 as select a,collect_list(b) as b1,collect_set(b) as b2 from dhua_test_001 group by a;

show create table dhua_test_002;

UDTF
-----------------------
LATERAL VIEW explode
lateralView: LATERAL VIEW udtf(expression) tableAlias AS columnAlias (',' columnAlias)*
fromClause: FROM baseTable (lateralView)*

-- pageid	adid_list
-- front_page	[1, 2, 3]
-- contact_page [3, 4, 5]
SELECT pageid, adid FROM pageAds LATERAL VIEW explode(adid_list) adTable AS adid;
SELECT adid, count(1) FROM pageAds LATERAL VIEW explode(adid_list) adTable AS adid GROUP BY adid;

-- Array<int> col1 	Array<string> col2
-- [1, 2] 	[a", "b", "c"]
-- [3, 4] 	[d", "e", "f"]
SELECT myCol1, col2 FROM baseTable LATERAL VIEW explode(col1) myTable1 AS myCol1;
SELECT myCol1, myCol2 FROM baseTable
LATERAL VIEW explode(col1) myTable1 AS myCol1
LATERAL VIEW explode(col2) myTable2 AS myCol2;
----
SELECT explode(myCol) AS myNewCol FROM myTable;
SELECT explode(myMap) AS (myMapKey, myMapValue) FROM myMapTable;
SELECT posexplode(myCol) AS pos, myNewCol FROM myTable;

-- 创建数组
select explode(array(1,2,3)) as a ;

select  value from tmp_sbu_pkgquerydb.dhuatmpwltracelog0712
LATERAL VIEW explode(str_to_map(value,'&','=')) b as vkey,vv
limit 5;

select explode(str_to_map(value,'&','=')) from tmp_sbu_pkgquerydb.dhuatmpwltracelog0712 
limit 5;

drop table if exists tmp_dhua_test_001;
create table tmp_dhua_test_001 as 
select explode(array('a\\b\\c')) as a
;

select * from tmp_dhua_test_001;
select regexp_replace(a,'\\',concat('\\,\\')) from tmp_dhua_test_001;




insert into table tmp_dhua_test_001
select 

select * from (
select value  
from source_ubtdb.tracelog 
where d='2015-09-01'
and key = 'pkg_list_load_online') a
LATERAL VIEW explode(str_to_map(value,'&','=')) b as k,v
limit 10;
;

select * from 
(select 'salescityid=2&kwd=(国内,,)&pkgnums=23385' as value) a
LATERAL VIEW explode(str_to_map(value,'&','=')) b as k,v
;


sqlserver:多行合并
-------
select id
,stuff((select ','+idc from #x b where a.id=b.id for xml path('')),1,1,'') as v
from #x a
group by pkg


create table tmp_sbu_pkgquerydb.dhuadimpage(
pageid bigint
,pagechan string
,pagetype string
,pagename string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
;

LOAD DATA 
LOCAL INPATH '/home/sbupkgread/dhua/dim/dimpage.txt' 
OVERWRITE INTO 
TABLE tmp_sbu_pkgquerydb.dhuadimpage;



SQLSERVER
========================
IF OBJECT_ID ('tempdb..#1') IS NOT NULL DROP TABLE #1

/* 全局变量、局部变量  @,#,##  */
print @@ServerName
print @@VERSION
select @@VERSION
declare @begindate as datetime,@enddate as datetime
set @begindate='2014-02-15'
set @enddate='2014-02-24'
print @begindate

/* 快捷键 
--Tools->Options->Environment->keyboard
--Query shortcuts:
--Ctrl+3	select top 5 * from
--ctrl+4	select count(1) as c from
*/

-- 日期函数
select getdate()
select datediff(day,'2015-01-01',getdate())
CONVERT(varchar(10),orderdate,120)


-- 生成随机数

USE [OLAP_TempDB]
go
--取得随机数的视图
drop view v_RAND
go
CREATE VIEW v_RAND
AS
SELECT re=RAND()
GO
 
--生成随机编号的函数
drop function f_RAND
go
CREATE FUNCTION f_RAND()
RETURNS decimal(18,17)
AS
BEGIN
    DECLARE @r decimal(18,17)
    SELECT @r=re FROM v_RAND
    RETURN(@r)
END
GO
 

select [OLAP_TempDB].dbo.f_RAND() as a

-- test -------------
drop table #a
create table #a(a bigint)
declare @b int
set @b=1
while (@b<=1000)
begin
insert into #a select @b
set @b=@b+1
end

select count(1) as c from #a

drop table #b
select a.a,b.a as b
into #b
from #a a,#a b

select count(1) as c from #b

select a,b,OLAP_TempDB.dbo.f_RAND() as r
into #c
from #b

select AVG(r) as r_avg,STDEV(r) as r_std,var(r) as r_var,1.0/12 as c_var
from #c
------------------------------------------------------------------------------


=====
正则表达式

[\\u0391-\\uFFE5]匹配双字节字符（汉字+符号） 

[\\u4e00-\\u9fa5]注意只匹配汉字，不匹配双字节字符 


比如[\\u4e00-\\u9fa5]只匹配我们看到的汉字，不匹配全角状态下输入的符号！？　［］等等 

[\\u0391-\\uFFE5]就匹配双字节字符 

汉字就是双字节字符，全角符号也是双字节字符 


用正则表达式限制只能输入中文：onkeyup="value=value.replace(/[^\u4E00-\u9FA5]/g,'')" onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\u4E00-\u9FA5]/g,''))" 

1.用正则表达式限制只能输入全角字符： onkeyup="value=value.replace(/[^\uFF00-\uFFFF]/g,'')" onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\uFF00-\uFFFF]/g,''))" 

2.用正则表达式限制只能输入数字：onkeyup="value=value.replace(/[^\d]/g,'') "onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" 

3.用正则表达式限制只能输入数字和英文：onkeyup="value=value.replace(/[\W]/g,'') "onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" 

4.计算字符串的长度（一个双字节字符长度计2，ASCII字符计1） 

String.prototype.len=function(){return this.replace([^\x00-\xff]/g,"aa").length;} 

5.javascript中没有像vbscript那样的trim函数，我们就可以利用这个表达式来实现，如下： 

String.prototype.trim = function() 
{ 
return this.replace(/(^\s*)|(\s*$)/g, ""); 
} 

利用正则表达式分解和转换IP地址： 

6.下面是利用正则表达式匹配IP地址，并将IP地址转换成对应数值的Javascript程序： 

function IP2V(ip) 
{ 
re=/(\d+)\.(\d+)\.(\d+)\.(\d+)/g //匹配IP地址的正则表达式 
if(re.test(ip)) 
{ 
return RegExp.$1*Math.pow(255,3))+RegExp.$2*Math.pow(255,2))+RegExp.$3*255+RegExp.$4*1 
} 
else 
{ 
throw new Error("不是一个正确的IP地址!") 
} 
} 

不过上面的程序如果不用正则表达式，而直接用split函数来分解可能更简单，程序如下： 

var ip="10.100.20.168" 
ip=ip.split(".") 
alert("IP值是："+(ip[0]*255*255*255+ip[1]*255*255+ip[2]*255+ip[3]*1)) 
正则表达式用于字符串处理、表单验证等场合，实用高效。现将一些常用的表达式收集于此，以备不时之需。 


匹配中文字符的正则表达式： [\u4e00-\u9fa5] 
评注：匹配中文还真是个头疼的事，有了这个表达式就好办了 

匹配双字节字符(包括汉字在内)：[^\x00-\xff] 
评注：可以用来计算字符串的长度（一个双字节字符长度计2，ASCII字符计1） 

匹配空白行的正则表达式：\n\s*\r 
评注：可以用来删除空白行 

匹配HTML标记的正则表达式：<(\S*?)[^>]*>.*?</\1>|<.*? /> 
评注：网上流传的版本太糟糕，上面这个也仅仅能匹配部分，对于复杂的嵌套标记依旧无能为力 

匹配首尾空白字符的正则表达式：^\s*|\s*$ 
评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式 

匹配Email地址的正则表达式：\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)* 
评注：表单验证时很实用 

匹配网址URL的正则表达式：[a-zA-z]+://[^\s]* 
评注：网上流传的版本功能很有限，上面这个基本可以满足需求 

匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$ 
评注：表单验证时很实用 

匹配国内电话号码：\d{3}-\d{8}|\d{4}-\d{7} 
评注：匹配形式如 0511-4405222 或 021-87888822 

匹配腾讯QQ号：[1-9][0-9]{4,} 
评注：腾讯QQ号从10000开始 

匹配中国邮政编码：[1-9]\d{5}(?!\d) 
评注：中国邮政编码为6位数字 

匹配身份证：\d{15}|\d{18} 
评注：中国的身份证为15位或18位 

匹配ip地址：\d+\.\d+\.\d+\.\d+ 
评注：提取ip地址时有用 

匹配特定数字： 
^[1-9]\d*$　 　 //匹配正整数 
^-[1-9]\d*$ 　 //匹配负整数 
^-?[1-9]\d*$　　 //匹配整数 
^[1-9]\d*|0$　 //匹配非负整数（正整数 + 0） 
^-[1-9]\d*|0$　　 //匹配非正整数（负整数 + 0） 
^[1-9]\d*\.\d*|0\.\d*[1-9]\d*$　　 //匹配正浮点数 
^-([1-9]\d*\.\d*|0\.\d*[1-9]\d*)$　 //匹配负浮点数 
^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0)$　 //匹配浮点数 
^[1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0$　　 //匹配非负浮点数（正浮点数 + 0） 
^(-([1-9]\d*\.\d*|0\.\d*[1-9]\d*))|0?\.0+|0$　　//匹配非正浮点数（负浮点数 + 0） 
评注：处理大量数据时有用，具体应用时注意修正 

匹配特定字符串： 
^[A-Za-z]+$　　//匹配由26个英文字母组成的字符串 
^[A-Z]+$　　//匹配由26个英文字母的大写组成的字符串 
^[a-z]+$　　//匹配由26个英文字母的小写组成的字符串 
^[A-Za-z0-9]+$　　//匹配由数字和26个英文字母组成的字符串 
^\w+$　　//匹配由数字、26个英文字母或者下划线组成的字符串 
评注：最基本也是最常用的一些表达式 

匹配中文字符的正则表达式： [\u4e00-\u9fa5] 

匹配双字节字符(包括汉字在内)：[^\x00-\xff] 

匹配空行的正则表达式：\n[\s| ]*\r 

匹配HTML标记的正则表达式：/<(.*)>.*<\/\1>|<(.*) \/>/  

匹配首尾空格的正则表达式：(^\s*)|(\s*$) 

匹配Email地址的正则表达式：\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)* 

匹配网址URL的正则表达式：http://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)? 


^\d+$　　//匹配非负整数（正整数 + 0）  
^[0-9]*[1-9][0-9]*$　　//匹配正整数  
^((-\d+)|(0+))$　　//匹配非正整数（负整数 + 0）  
^-[0-9]*[1-9][0-9]*$　　//匹配负整数  
^-?\d+$　　　　//匹配整数  
^\d+(\.\d+)?$　　//匹配非负浮点数（正浮点数 + 0）  
^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$　　//匹配正浮点数  
^((-\d+(\.\d+)?)|(0+(\.0+)?))$　　//匹配非正浮点数（负浮点数 + 0）  
^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$　　//匹配负浮点数  
^(-?\d+)(\.\d+)?$　　//匹配浮点数  
^[A-Za-z]+$　　//匹配由26个英文字母组成的字符串  
^[A-Z]+$　　//匹配由26个英文字母的大写组成的字符串  
^[a-z]+$　　//匹配由26个英文字母的小写组成的字符串  
^[A-Za-z0-9]+$　　//匹配由数字和26个英文字母组成的字符串  
^\w+$　　//匹配由数字、26个英文字母或者下划线组成的字符串  
^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$　　




[\\u0391-\\uFFE5]就匹配双字节字符 

hive 匹配中文 rlike '^[\\u4e00-\\u9fa5]+$';


[\\u0000-\\u007f\\u0391-\\uFFE5]

