set hivevar:startdate=2016-05-01;
set hivevar:enddate=2017-01-24;

use tmp_sbu_pkgquerydb;
create table tmp_df_xjd_01 as 
select * from dw_mobdb.members
where signupdate>="${startdate}" and signupdate< "${enddate}"
;

use tmp_sbu_pkgquerydb;
drop table if exists tmp_dhua_out_member;
create table tmp_dhua_out_member as 
select lower(a.uid) as uid
,regexp_replace(username,'["\t\\\\]','') as  username
,case when emailvalid='T' then if(lower(email) rlike '^(nomail|noemail|no)@' 
      or lower(email) rlike '^(noname|nomai|namail|normal|nomial)@ctrip'
      or lower(email) rlike '^(noamil|normail|noemai|none|nimail|nomaill|naomail|nomali|noamail|nonel|nomal)@ctrip'
      or lower(email) rlike '^(nomaiel|noami|nomaii|nomeanil|nromal|noy|noemial|noctrip|nomil|normai|nomoail)@ctrip'
      or lower(email) rlike '^(noemaiil|notmail|noma|nono|noomail|nobody|noemil|nmail)@ctrip'
      or lower(email) rlike '^(nomair|nomailo|noen|nonail|nomauil|nomarl|nomei|nomaile|nomanil)@ctrip'
      or lower(email) in('123456@qq.com','a@b.com','a@a.com','e@e.com','none@none.com','ctrip@5161.com.cn','qq@123567.cn','123@qq.com') 
     ,null ,regexp_extract(lower(email),'([A-Za-z0-9_\\-\\.]+@[A-Za-z0-9_\\-\\.]+)',1)) else NULL end as email
,case when mobilevalid='T' then regexp_extract(regexp_replace(regexp_replace(regexp_replace(regexp_replace(a.mobilephone,'[\s \\-\\\\]',''),'^\\+86','')
     ,'^(\\+1|\\*1|01|001)','1'),'^0086',''),'([0-9]{11,20})',1) else NULL end as mobilephone
,regexp_extract(regexp_replace(regexp_replace(regexp_replace(regexp_replace(b.mobilephone,'[\s \\-\\\\]',''),'^\\+86',''),'^(\\+1|\\*1|01|001)','1'),'^0086','')
     ,'([0-9]{11,20})',1) as mobilephone_relate
,regexp_extract(regexp_replace(regexp_replace(regexp_replace(regexp_replace(tel,'[\s \\-\\\\]',''),'^\\+86',''),'^(\\+1|\\*1|01|001)','1'),'^0086','')
     ,'([0-9]{11,20})',1) as tel
,case when lower(gender) in ('m','f') then lower(gender) else NULL end as gender
,to_date(birth) as birth
,regexp_replace(idcardno,'["\t\\\\]','') as idcardno
,to_date(signupdate) as signupdate
from tmp_df_xjd_01 a
left outer join dw_pubdb.factuidrelatemobile b on lower(a.uid)=lower(b.uid)
where  (emailvalid='T' or mobilevalid='T' or b.mobilephone is not null )
and lower(a.uid) not in ('ctriptestat','13845612110','test111111','13845611999','wwwwww', 'test1111','test111111','wwwwwww','ctriptest')
and lower(a.uid) not in ('jerrygao','15801788888','19876543211')
-- and lower(a.uid) not in ('djyd','jjyd')
;


-- 修正
use tmp_sbu_pkgquerydb;
drop table if exists tmp_dhua_out_member_2;
create table tmp_dhua_out_member_2 as 
select uid
,username
,email
,coalesce(if(mobilephone rlike '^1[0-9]{10}$',mobilephone,null),if(tel rlike '^1[0-9]{10}$',tel,null)) as mobilephone
,if(mobilephone_relate rlike '^1[0-9]{10}$',mobilephone_relate,null) as mobilephone_relate
,gender
,birth
,if(length(idcardno)<3,null,idcardno) as idcardno
,signupdate
from tmp_dhua_out_member
;


use tmp_sbu_pkgquerydb;
set hive.exec.dynamic.partition.mode=nonstrict; 
set hivevar:startdate=2017-01-01; 
set hivevar:enddate=2017-02-01;
insert OVERWRITE table tmp_xjd_out_str partition (d)  
select uid,username,email,mobilephone,mobilephone_relate,gender,birth,idcardno,signupdate
from tmp_dhua_out_member_2
where signupdate>="${startdate}" and signupdate<"${enddate}"
;

use tmp_sbu_pkgquerydb;
drop table tmp_df_xjd_01;
drop table tmp_dhua_out_member;
drop table tmp_dhua_out_member_2;

use tmp_sbu_pkgquerydb;
CREATE TABLE `tmp_xjd_out_str`(
`uid` string,
`username` string,
`email` string,
`mobilephone` string,
`mobilephone_relate` string,
`gender` string,
`birth` string,
`idcardno` string)
PARTITIONED BY (`d` string COMMENT 'date');


-- mysql 

create table member(
uid varchar(30),
username varchar(100),
email varchar(60),
mobilephone varchar(20),
tel varchar(30),
gender char(1),
birth date,
idcardno varchar(20),
signupdate date
)ENGINE=MyISAM DEFAULT CHARSET=utf8
;


LOAD DATA LOCAL INFILE 'D:\\Users\\dhua\\day\\doc\\other\\data\\member\\member16m1t3.txt' 
INTO TABLE member 
CHARACTER SET utf8 
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\\' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
;




  
