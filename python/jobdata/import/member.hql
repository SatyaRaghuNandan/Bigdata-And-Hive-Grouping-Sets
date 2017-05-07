

/*
uid idcardno
*/

use tmp_sbu_pkgquerydb;
set hive.exec.dynamic.partition.mode=nonstrict; 
set hivevar:startdate=${zdt.addDay(-31).format("yyyy-MM-dd")}; 
set hivevar:enddate=${zdt.format("yyyy-MM-dd")};

select ud,ic 
from tmp_diydb.tmp_diy_dimprd_segment_resource
where d>='${startdate}' and d<'${enddate}'
and length(ic)>5
;

-- adhoc
select ud,ic 
from tmp_diydb.tmp_diy_dimprd_segment_resource
where d>='2017-03-02' and d<'2017-03-03'
and length(ic)>5
;


/*
to sbupkgread
*/
use tmp_sbu_pkgquerydb;
set hive.exec.dynamic.partition.mode=nonstrict; 
set hivevar:startdate=${zdt.addDay(-31).format("yyyy-MM-dd")}; 
set hivevar:enddate=${zdt.format("yyyy-MM-dd")};

insert OVERWRITE table tmp_adp_online_cza partition (d)
select ud,ct,zp,ar,d
from tmp_diydb.tmp_diy_dimprd_segment_resource
where d>='${startdate}' and d<'${enddate}'
and length(ar)>3
;

insert OVERWRITE table tmp_juhe_sddnl partition (d)
select ud,un,ml,mp,gd,bt,ct,tl,d
from tmp_diydb.tmp_diy_dimprd_segment_resource
where d>='${startdate}' and d<'${enddate}'
;

-- delete tmp_diydb
use tmp_diydb;
alter table tmp_diy_dimprd_segment_resource drop partition (d>='0')

/*
uid address
*/
-- zeus
use tmp_sbu_pkgquerydb;
set hive.exec.dynamic.partition.mode=nonstrict; 
set hivevar:startdate=${zdt.addDay(-31).format("yyyy-MM-dd")}; 
set hivevar:enddate=${zdt.format("yyyy-MM-dd")};

use tmp_sbu_pkgquerydb;
drop table tmp_diy_online_pkg;
create table tmp_diy_online_pkg as 
select ud,nvl(ct,'') as ct,nvl(zp,'') as zp,nvl(ar,'') as ar
from tmp_adp_online_cza
where d>='0'
;

--adhoc

select * from tmp_sbu_pkgquerydb.tmp_diy_online_pkg;

-- after address

use tmp_sbu_pkgquerydb;
drop table tmp_diy_online_pkg;
alter table tmp_adp_online_cza drop partition (d>='0');


/*
uid info
*/

-- zeus
use tmp_sbu_pkgquerydb;
set hive.exec.dynamic.partition.mode=nonstrict; 
set hivevar:startdate=${zdt.addDay(-31).format("yyyy-MM-dd")}; 
set hivevar:enddate=${zdt.format("yyyy-MM-dd")};

set hivevar:startdate=2017-01-01; 
set hivevar:enddate=2017-01-08;

use tmp_sbu_pkgquerydb;
drop table tmp_diy_online_pkg;
create table tmp_diy_online_pkg as 
select ud
,nvl(un,'') as un
,nvl(ml,'') as ml
,nvl(mp,'') as mp
,nvl(gd,'') as gd
,nvl(bt,'') as bt
,nvl(ct,0) as ct
,nvl(tl,'') as tl
,d
from tmp_juhe_sddnl
where d>='0'
;

use tmp_sbu_pkgquerydb;
alter table tmp_juhe_sddnl drop partition (d<'2017-03-01')

select * from tmp_sbu_pkgquerydb.tmp_diy_online_pkg;
select d,count(1) as pv from tmp_sbu_pkgquerydb.tmp_juhe_sddnl where d>'1' group by d


/*
route
*/


use tmp_diydb;
set hive.exec.dynamic.partition.mode=nonstrict; 

set hivevar:startdate=2017-02-01; 
set hivevar:enddate=2017-02-28;


insert OVERWRITE table tmp_diy_dimprd_segment_resource partition (d)
select uid,username,email,mobilephone,gender,birth
,city,zip,address,tel,d
from dw_mobdb.members_new
where d>='${startdate}' and d<'${enddate}'
and (length(email) > 6 or length(mobilephone)>8)
;


hive -e " use tmp_diydb;alter table tmp_diy_dimprd_segment_resource drop partition (d<'${pre_month}');insert OVERWRITE table tmp_diy_dimprd_segment_resource partition (d='${pre_date}') select uid,username,email,mobilephone,gender,birth,city,idcardno,zip,address,tel from dw_mobdb.members_new where d ='${pre_date}' and (length(email) > 6 or length(mobilephone)>8)"

-----------------------
-- step1

use tmp_sbu_pkgquerydb;
CREATE  TABLE tmp_juhe_sddnl(
  ud string, 
  un string,
  ml string,
  mp string,
  gd string,
  bt string,
  ct string,
  tl string
)
partitioned by (d string)
STORED AS RCFILE;


use tmp_sbu_pkgquerydb;
drop table tmp_adp_online_cza;
CREATE  TABLE tmp_adp_online_cza(
  ud string, 
  ct string,
  zp string,
  ar string
)
partitioned by (d string)
STORED AS RCFILE;

use tmp_diydb;
drop table tmp_diy_dimprd_segment_resource;
CREATE  TABLE tmp_diy_dimprd_segment_resource(
  ud string, 
  un string,
  ml string,
  mp string,
  gd string,
  bt string,
  ct string,
  ic string,
  zp string,
  ar string,
  tl string
)
partitioned by (d string)
STORED AS RCFILE;

-------------------------------------------

-- delete table 

use tmp_sbu_pkgquerydb;
alter table tmp_juhe_sddnl drop partition (d>='0');
alter table tmp_adp_online_cza drop partition (d>='0');

use tmp_diydb;
alter table tmp_diy_dimprd_segment_resource drop partition (d>='0')

---------------



