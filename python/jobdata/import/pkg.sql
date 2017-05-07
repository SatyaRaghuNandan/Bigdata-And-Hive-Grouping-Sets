-- pkg.order
use tmp_diydb;

set hivevar:startdate=2017-01-01; 
set hivevar:enddate=2017-02-01;


drop table if exists tmp_dhua_001;
create table tmp_dhua_001 as
SELECT lower(regexp_replace(uid,'["\t\\\\]','')) as uid
,nvl(pkg,0) as pkgid
,nvl(orderid,0) as orderid
,case when orderstatus in ('已成交','已成交(部分退订)') then 'S'
    when orderstatus in ('已成交(全部退订)') then 'R'
    when orderstatus in ('处理中','已提交未处理','已收款','待处理','等待','部分扣款') then 'P'
    else 'C' end as orderstatus
,channel_name as bu,productcategoryname,productpatternname,typedesc,salemode
,orderdatetime as orderdate,startdate,returndate
,nvl(startcityid,0) as startcityid
,nvl(salescityid,0) as salescityid
,nvl(destcityid,0) as destcityid
,persons,numadult,numchild,numbaby,amount,cost,profit
,regexp_replace(contactname,'["\t\\\\]','') as contactname
,regexp_replace(contacttel,'["\t\\\\]','') as contacttel
,regexp_replace(contactmobile,'["\t\\\\]','') as contactmobile
,regexp_replace(contactemail,'["\t\\\\]','') as contactemail
,regexp_replace(pkgname,'["\t\\\\]','') as pkgname
from dw_groupdb.t_lhy_factpkgorder
where orderdatetime>="${startdate}" and orderdatetime<"${enddate}"
;

select count(1) from tmp_diydb.tmp_dhua_001;
select * from tmp_diydb.tmp_dhua_001;
-- pkgorder2017m1

-- TODO 

-- pkg.dimpkg
use tmp_diydb;
drop table if exists tmp_dhua_001;
create table tmp_dhua_001 as
SELECT distinct pkg as pkgid,channel_name as bu
from dw_groupdb.t_lhy_factpkgorder
where orderdatetime>="${startdate}" and orderdatetime<"${enddate}"
and pkg is not null and pkg<>0
and channel_name in ('团队游','邮轮','游学','主题游','自由行')
;

use tmp_diydb;
drop table if exists tmp_dhua_002;
create table tmp_dhua_002 as 
select pkgid
,regexp_replace(b.pkgname,'["\t\\\\]','') as pkgname
,b.destcity as destcityid
,b.productcategoryid as categoryid
,b.productpatternid as patternid
,b.salemode
,b.vendorid
,c.vendorid as vendorid_src
,regexp_replace(b.vendorbookingcontact,'["\t\\\\]','') as vendorcontact
,regexp_replace(b.vendorbookingphone,'["\t\\\\]','') as vendorphone
,regexp_replace(b.vendorbookingemergencycontact,'["\t\\\\]','') as vendorcontact_emergency
,regexp_replace(b.vendorbookingemergencyphone,'["\t\\\\]','') as vendorphone_emergency
from tmp_dhua_001 a 
left outer join dim_pkgdb.dimpkgpkg b on a.pkgid=b.pkg
left outer join dw_groupdb.dwsbu_dw_diydb_temp_pkg c on a.pkgid=c.pkg
where length(b.pkgname)>2
;

select count(1) from tmp_diydb.tmp_dhua_002;
select * from tmp_diydb.tmp_dhua_002;
-- dimpkg2017m1

-- pkg.provider
use tmp_diydb;
drop table if exists tmp_dhua_003;
create table tmp_dhua_003 as
select distinct vendorid
from(
select vendorid from tmp_dhua_002
union all
select vendorid_src as vendorid from tmp_dhua_002
) a 
;

use tmp_diydb;
drop table if exists tmp_dhua_001;
create table tmp_dhua_001 as 
select provider
,regexp_replace(providername,'["\t\\\\]','') as providername
,regexp_replace(providershortname,'["\t\\\\]','') as providershortname
,corpfounddate
,regexp_replace(corplegalperson,'["\t\\\\]','') as corplegalperson
,regexp_replace(corpregistercapital,'["\t\\\\]','') as corpregistercapital
,qualifyeffectdate
,qualifyexpiredate
,regexp_replace(corpinterareacode,'["\t\\\\]','') as corpinterareacode
,regexp_replace(corpcityareacode,'["\t\\\\]','') as corpcityareacode
,regexp_replace(corpfixedtel,'["\t\\\\]','') as corpfixedtel
,regexp_replace(regexp_replace(corpwebsite,'["\t]',''),'\\\\','\\\\\\\\') as corpwebsite
,regexp_replace(address,'["\t\\\\]','') as address
,zip
,city
,providercountry
,regexp_replace(providertype,'["\t\\\\]','') as providertype
,regexp_replace(providertypes,'["\t\\\\]','') as providertypes
,providercategory
,isvbooking
,dimentionbiz
,dimentionimportance
,dimentionpurchase
,contracteffectdate
,lastcontractsigneddate
,contractexpiredate
,regexp_replace(ctripfirstbizcontactname,'["\t\\\\]','') as ctripfirstbizcontactname
,regexp_replace(ctripfirstbiztel,'["\t\\\\]','') as ctripfirstbiztel
,regexp_replace(ctripfirstbizemail,'["\t\\\\]','') as ctripfirstbizemail
,regexp_replace(ctripsecondbizcontactname,'["\t\\\\]','') as ctripsecondbizcontactname
,regexp_replace(ctripsecondbiztel,'["\t\\\\]','') as ctripsecondbiztel
,regexp_replace(ctripsecondbizemail,'["\t\\\\]','') as ctripsecondbizemail
,regexp_replace(financecontact,'["\t\\\\]','') as financecontact
,regexp_replace(financetel,'["\t\\\\]','') as financetel
,regexp_replace(fncontactmobile,'["\t\\\\]','') as fncontactmobile
,regexp_replace(fncontactemail,'["\t\\\\]','') as fncontactemail
,regexp_replace(contactname,'["\t\\\\]','') as contactname
,regexp_replace(contacttel,'["\t\\\\]','') as contacttel
,regexp_replace(bookmobile,'["\t\\\\]','') as bookmobile
,regexp_replace(bookemail,'["\t\\\\]','') as bookemail
from ods_pkgproductdb.PkgProvider a 
inner join tmp_dhua_003 b on a.provider=b.vendorid
;

select count(1) from tmp_diydb.tmp_dhua_001;
select * from tmp_diydb.tmp_dhua_001;
pkgprovider2017m1


use tmp_diydb;
drop table tmp_dhua_001;
drop table tmp_dhua_002;
drop table tmp_dhua_003;


-- pkg.client
sqlserver (10.8.77.41,28747)

drop table #pkgorder
SELECT uid,orderid,orderdate
into #pkgorder
FROM [DW_DIYDB].[dbo].[T_LHY_FactPkgOrder]
where orderdate>='2017-01-01' and orderdate<'2017-02-01'

drop table #pkgclient
select uid,orderid,orderdate
,REPLACE(REPLACE(REPLACE(clientname,CHAR(9),' '),CHAR(10),' '),CHAR(13),' ') as clientname
,REPLACE(REPLACE(REPLACE(clientename,CHAR(9),' '),CHAR(10),' '),CHAR(13),' ') as clientename
,REPLACE(REPLACE(REPLACE(birthdate,CHAR(9),' '),CHAR(10),' '),CHAR(13),' ') as birthdate
,REPLACE(REPLACE(REPLACE(gender,CHAR(9),' '),CHAR(10),' '),CHAR(13),' ') as gender
,REPLACE(REPLACE(REPLACE(idcardtype,CHAR(9),' '),CHAR(10),' '),CHAR(13),' ') as idcardtype
,REPLACE(REPLACE(REPLACE(idcardno,CHAR(9),' '),CHAR(10),' '),CHAR(13),' ') as idcardno
,REPLACE(REPLACE(REPLACE(nationality,CHAR(9),' '),CHAR(10),' '),CHAR(13),' ') as nationality
,REPLACE(REPLACE(REPLACE(cardcity,CHAR(9),' '),CHAR(10),' '),CHAR(13),' ') as cardcity 
,REPLACE(REPLACE(REPLACE(mobile,CHAR(9),' '),CHAR(10),' '),CHAR(13),' ') as mobile
into #pkgclient
from (
select a.uid,a.orderid,a.orderdate 
,clientname,clientname_e as clientename,birthdate,gender,idcardtype,idcardno,nationality,cardcity 
,'' as mobile 
from dw_pkgdb.dbo.factpkgclient a (nolock) 
where orderdate>='2017-01-01' and orderdate<'2017-02-01'
union all 
select b.uid,b.orderid,b.orderdate 
,cnnname as clientname,engname as clientename,birthdate 
,case when gender =0 then 'F' when gender=1 then 'M' else NULL end as gender 
,certificate as idcardtype,certificateno as idcardno 
,nationnality as nationality,null as cardcity 
,mobile
from dw_diydb.dbo.fact_diy_passengers a  (nolock) 
inner join #pkgorder b on a.orderid=b.orderid 
union all 
select b.uid,b.orderid,b.orderdate 
,clientname,clientename, birthdate,gender,idcardtype,idcardno,nationality,cardcity 
,contactinfo as mobile
from dw_cruisedb.dbo.factcruisecustomerinfo a  (nolock)  
inner join #pkgorder b on a.orderid=b.orderid 
) a 

select * from #pkgclient
-- pkgclient2017m1


-- TODO 

-- 资源，备选
drop table #pkgpkg
SELECT distinct pkg
into #pkgpkg
FROM [DW_DIYDB].[dbo].[T_LHY_FactPkgOrder]
where orderdate>='2017-01-01' and orderdate<'2017-02-01'
and ProductPatternName in ('跟团游','半自助游','私家团','自由行')

drop table #pkgresource
select  a.pkg,c.ProductID as resourceid,c.ChoiceMode
,d.vendorid,d.productid as productid_v,d.name as productname_v,d.producttype as producttype_v
into #pkgresource
from #pkgpkg a 
inner join [Dim_DB].[dbo].[DimPkg_ProductSegment] b on a.pkg=b.productid
inner join [Dim_DB].[dbo].[DimPkg_SegmentResource] c on b.segmentid=c.segmentid
inner join [Dim_DB].[dbo].[DimPkg_Product] d on c.productid=d.productid

--产品资源id
select distinct pkg,resourceid
into #pkgresourceid
from #pkgresource

--资源信息
select distinct resourceid,productid_v,productname_v,vendorid
into #resource
from #pkgresource


select * from #pkgresourceid

select resourceid,vendorid,REPLACE(REPLACE(REPLACE(productname_v,CHAR(9),' '),CHAR(10),' '),CHAR(13),' ') as resoucename from #resource




-- 维表
[Dim_DB].[dbo].[DimPkg_ProductCategory]
[Dim_DB].[dbo].[DimPkg_ProductPattern]



-- sqlserver 验证 线路产品的资源信息()
select  a.pkg,a.pkgname,a.producttype
,b.segmentid,b.SegmentNumber
,c.ProductID as resourceid,c.ChoiceMode,c.SequenceNumber
,d.vendorid,d.productid as productid_ven,d.name as name_ven
,e.providername,e.providertype
from [DW_PkgDB].[dbo].[DimPKG] a 
inner join [Dim_DB].[dbo].[DimPkg_ProductSegment] b on a.pkg=b.productid
inner join [Dim_DB].[dbo].[DimPkg_SegmentResource] c on b.segmentid=c.segmentid
inner join [Dim_DB].[dbo].[DimPkg_Product] d on c.productid=d.productid
left outer join [DW_PkgDB].[dbo].[DimProvider] e on d.vendorid=e.Provider
where a.pkg=11950084
and a.producttype in ('L')



