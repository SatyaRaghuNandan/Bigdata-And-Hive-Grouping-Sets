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

/*多行合并
*/
select id
,stuff((select ','+idc from #x b where a.id=b.id for xml path('')),1,1,'') as v
from #x a
group by pkg

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



数据库 select * from sys.sysdatabases 
数据表 select * from @dbname.sys.tables

SQL Server判断对象是否存在 (if exists (select * from sysobjects )(转)
1 判断数据库是否存在
Sql代码 
if exists (select * from sys.databases where name = ’数据库名’)  
  drop database [数据库名]  if exists (select * from sys.databases where name = ’数据库名’)
  drop database [数据库名]
2 判断表是否存在
Sql代码 
if exists (select * from sysobjects where id = object_id(N’[表名]’) and OBJECTPROPERTY(id, N’IsUserTable’) = 1)  
  drop table [表名]  if exists (select * from sysobjects where id = object_id(N’[表名]’) and OBJECTPROPERTY(id, N’IsUserTable’) = 1)
  drop table [表名]
3 判断存储过程是否存在
Sql代码 
if exists (select * from sysobjects where id = object_id(N’[存储过程名]’) and OBJECTPROPERTY(id, N’IsProcedure’) = 1)  
  drop procedure [存储过程名]  if exists (select * from sysobjects where id = object_id(N’[存储过程名]’) and OBJECTPROPERTY(id, N’IsProcedure’) = 1)
  drop procedure [存储过程名]
4 判断临时表是否存在
Sql代码 
if object_id(’tempdb..#临时表名’) is not null    
  drop table #临时表名  if object_id(’tempdb..#临时表名’) is not null  
  drop table #临时表名 
5 判断视图是否存在
Sql代码 
--SQL Server 2000   
IF EXISTS (SELECT * FROM sysviews WHERE object_id = ’[dbo].[视图名]’  
--SQL Server 2005   
IF EXISTS (SELECT * FROM sys.views WHERE object_id = ’[dbo].[视图名]’  --SQL Server 2000
IF EXISTS (SELECT * FROM sysviews WHERE object_id = ’[dbo].[视图名]’
--SQL Server 2005
IF EXISTS (SELECT * FROM sys.views WHERE object_id = ’[dbo].[视图名]’
6 判断函数是否存在
Sql代码 
--  判断要创建的函数名是否存在    
  if exists (select * from dbo.sysobjects where id = object_id(N’[dbo].[函数名]’) and xtype in (N’FN’, N’IF’, N’TF’))    
  drop function [dbo].[函数名]    --  判断要创建的函数名是否存在  
  if exists (select * from dbo.sysobjects where id = object_id(N’[dbo].[函数名]’) and xtype in (N’FN’, N’IF’, N’TF’))  
  drop function [dbo].[函数名]  
7 获取用户创建的对象信息 
Sql代码 
SELECT [name],[id],crdate FROM sysobjects where xtype=’U’  
  
/*  
xtype 的表示参数类型，通常包括如下这些  
C = CHECK 约束  
D = 默认值或 DEFAULT 约束  
F = FOREIGN KEY 约束  
L = 日志  
FN = 标量函数  
IF = 内嵌表函数  
P = 存储过程  
PK = PRIMARY KEY 约束（类型是 K）  
RF = 复制筛选存储过程  
S = 系统表  
TF = 表函数  
TR = 触发器  
U = 用户表  
UQ = UNIQUE 约束（类型是 K）  
V = 视图  
X = 扩展存储过程  
*/  SELECT [name],[id],crdate FROM sysobjects where xtype=’U’
/*
xtype 的表示参数类型，通常包括如下这些
C = CHECK 约束
D = 默认值或 DEFAULT 约束
F = FOREIGN KEY 约束
L = 日志
FN = 标量函数
IF = 内嵌表函数
P = 存储过程
PK = PRIMARY KEY 约束（类型是 K）
RF = 复制筛选存储过程
S = 系统表
TF = 表函数
TR = 触发器
U = 用户表
UQ = UNIQUE 约束（类型是 K）
V = 视图
X = 扩展存储过程
*/
8 判断列是否存在
Sql代码 
if exists(select * from syscolumns where id=object_id(’表名’) and name=’列名’)  
  alter table 表名 drop column 列名  if exists(select * from syscolumns where id=object_id(’表名’) and name=’列名’)
  alter table 表名 drop column 列名
9 判断列是否自增列
Sql代码 
if columnproperty(object_id(’table’),’col’,’IsIdentity’)=1  
  print ’自增列’  
else  
  print ’不是自增列’  
  
SELECT * FROM sys.columns WHERE object_id=OBJECT_ID(’表名’)  
AND is_identity=1  if columnproperty(object_id(’table’),’col’,’IsIdentity’)=1
  print ’自增列’
else
  print ’不是自增列’
SELECT * FROM sys.columns WHERE object_id=OBJECT_ID(’表名’)
AND is_identity=1
10 判断表中是否存在索引
Sql代码 
if exists(select * from sysindexes where id=object_id(’表名’) and name=’索引名’)    
  print  ’存在’    
else    
  print  ’不存在  if exists(select * from sysindexes where id=object_id(’表名’) and name=’索引名’)  
  print  ’存在’  
else  
  print  ’不存在
11 查看数据库中对象
Sql代码 
SELECT * FROM sys.sysobjects WHERE name=’对象名’  SELECT * FROM sys.sysobjects WHERE name=’对象名’