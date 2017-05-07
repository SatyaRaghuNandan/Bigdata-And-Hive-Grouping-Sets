tmp_dhua_out_orders_day
tmp_dhua_out_contact_day
tmp_dhua_out_client_day

tmp_dhua_out_htl_order_ext
tmp_dhua_out_flt_order_ext
tmp_dhua_out_flt_order_seg

-----------------------
tmp_dhua_out_etl_orders
tmp_dhua_out_etl_contact

---------------------
set hivevar:startdate=2016-06-01;
set hivevar:enddate=2016-06-16;

use tmp_sbu_pkgquerydb;

set hive.exec.dynamic.partition.mode=nonstrict; 
set hivevar:startdate=${zdt.addDay(-1).format("yyyy-MM-dd")}; 
set hivevar:enddate=${zdt.format("yyyy-MM-dd")};

insert overwrite table tmp_dhua_out_etl_orders partition(d)
select lower(regexp_replace(uid,'["\t\\\\]','')) as uid
,ordertype,orderid,orderdate
,case when orderstatus='处理中' then 'P' when orderstatus='等待' then 'W' when orderstatus='结束' then 'S' else orderstatus end as orderstatus
,quantity,amount,cost
,d
from tmp_dhua_out_orders_day
where d>="${startdate}" and d<"${enddate}"
;

alter table tmp_dhua_out_orders_day drop partition (d<"${enddate}");

insert overwrite table tmp_dhua_out_etl_contact partition(d)
select lower(regexp_replace(uid,'["\t\\\\]','')) as uid,ordertype,orderid
,nvl(regexp_replace(lower(cname),'["\t\\\\]',''),'') as cname
,coalesce(if(regexp_extract(regexp_replace(regexp_replace(regexp_replace(regexp_replace(mobile,'[\s \\-"\t\\\\]',''),'^\\+86',''),'^(\\+1|\\*1|01|001)','1'),'^0086','')
 ,'([0-9]{11,20})',1) rlike '^1[0-9]{10}$',regexp_extract(regexp_replace(regexp_replace(regexp_replace(regexp_replace(mobile,'[\s \\-"\t\\\\]',''),'^\\+86',''),'^(\\+1|\\*1|01|001)','1'),'^0086',''),'([0-9]{11,20})',1),null)
 ,if(regexp_extract(regexp_replace(regexp_replace(regexp_replace(regexp_replace(tel,'[\s \\-"\t\\\\]',''),'^\\+86',''),'^(\\+1|\\*1|01|001)','1'),'^0086',''),'([0-9]{11,20})',1) rlike '^1[0-9]{10}$',regexp_extract(regexp_replace(regexp_replace(regexp_replace(regexp_replace(tel,'[\s \\-"\t\\\\]',''),'^\\+86',''),'^(\\+1|\\*1|01|001)','1'),'^0086',''),'([0-9]{11,20})',1),null)
 ,'') as mobile
,if(lower(email) rlike '^(nomail|noemail|no)@' 
      or lower(email) rlike '^(noname|nomai|namail|normal|nomial)@ctrip'
      or lower(email) rlike '^(noamil|normail|noemai|none|nimail|nomaill|naomail|nomali|noamail|nonel|nomal)@ctrip'
      or lower(email) rlike '^(nomaiel|noami|nomaii|nomeanil|nromal|noy|noemial|noctrip|nomil|normai|nomoail)@ctrip'
      or lower(email) rlike '^(noemaiil|notmail|noma|nono|noomail|nobody|noemil|nmail)@ctrip'
      or lower(email) rlike '^(nomair|nomailo|noen|nonail|nomauil|nomarl|nomei|nomaile|nomanil)@ctrip'
      or lower(email) in('123456@qq.com','a@b.com','a@a.com','e@e.com','none@none.com','ctrip@5161.com.cn') 
      or length(email)<6
      ,''
      ,regexp_extract(regexp_replace(lower(email),'["\t\\\\]',''),'([A-Za-z0-9_\\-\\.]+@[A-Za-z0-9_\\-\\.]+)',1)
    ) as email
,d
from tmp_dhua_out_contact_day
where d>="${startdate}" and d<"${enddate}"
;

alter table tmp_dhua_out_contact_day drop partition (d<"${enddate}");


insert overwrite table tmp_dhua_out_etl_client partition(d)
select lower(regexp_replace(uid,'["\t\\\\]','')) as uid,ordertype,orderid
,regexp_replace(cname,'["\t\\\\]','') as cname
,regexp_replace(ename,'["\t\\\\]','') as ename
,to_date(birth) as birth
,case when gender in('0','f','F') then 'F' when gender in('1','m','M') then 'M' else null end as gender
,cardtype
,regexp_replace(cardno,'["\t\\\\]','') as cardno
,regexp_replace(nation,'["\t\\\\]','') as nation
,regexp_replace(cardcity,'["\t\\\\]','') as cardcity
,d
from tmp_dhua_out_client_day
where d>="${startdate}" and d<"${enddate}"
and lower(uid) not in ('ctriptestat','13845612110','test111111','13845611999','wwwwww', 'test1111','test111111','wwwwwww','ctriptest')
and lower(uid) not in ('jerrygao','15801788888','19876543211')
;

alter table tmp_dhua_out_client_day drop partition (d<"${enddate}");



-- 防止分区过多，删除2个月之前的分区
set hivevar:minpartdate=${zdt.add(2,-1).format("yyyy-MM-dd")};

alter table tmp_dhua_out_etl_client drop partition (d<"${minpartdate}");
alter table tmp_dhua_out_etl_contact drop partition (d<"${minpartdate}");
alter table tmp_dhua_out_etl_orders drop partition (d<"${minpartdate}");
alter table tmp_dhua_out_flt_order_ext drop partition (d<"${minpartdate}");
alter table tmp_dhua_out_flt_order_seg drop partition (d<"${minpartdate}");
alter table tmp_dhua_out_htl_order_ext drop partition (d<"${minpartdate}");

-- alter table xxx drop partition (d<"${minpartdate}");




-----------------
-- todo
select gender,count(1) as c from tmp_dhua_out_client_day where d='2016-06-15' group by gender order by c desc limit 10000;


lower(regexp_replace(uid,'["\t\\\\]','')) as uid

concat(year(d),'-',if(month(d)<10,'0',''),month(d)) as d

,if(birthdate<'1901-01-01',null,birthdate) as birthdate,gender
,regexp_replace(upper(nationality),'[^A-Z\\u4e00-\\u9fa5]','') as nationality
,regexp_replace(upper(cardcity),'[^A-Z\\u4e00-\\u9fa5]','') as cardcity

-- 身份证正则: '(^[1-9][0-9]{14}$|^[1-9][0-9]{16}[0-9xX]$)'
select nationality,count(1) as c from tmp_dhua_out_client_pkg_2 where nationality rlike '[\\u4e00-\\u9fa5]+' group by nationality;
where idcardtype=1 and length(idcardno)=18


----------------------------------------------------



use tmp_sbu_pkgquerydb;

CREATE  TABLE `tmp_dhua_out_etl_orders`(
  `uid` string, 
  `ordertype` string, 
  `orderid` bigint, 
  `orderdate` string, 
  `orderstatus` string, 
  `quantity` int, 
  `amount` double, 
  `cost` double)
PARTITIONED BY (`d` string)
;

CREATE  TABLE `tmp_dhua_out_etl_contact`(
  `uid` string, 
  `ordertype` string, 
  `orderid` bigint, 
  `cname` string, 
  `mobile` string, 
  `email` string)
PARTITIONED BY ( `d` string)
;

CREATE  TABLE `tmp_dhua_out_etl_client`(
  `uid` string, 
  `ordertype` string, 
  `orderid` bigint, 
  `cname` string, 
  `ename` string, 
  `birth` string, 
  `gender` string, 
  `cardtype` int, 
  `cardno` string, 
  `nation` string, 
  `cardcity` string)
PARTITIONED BY (`d` string)
;
















