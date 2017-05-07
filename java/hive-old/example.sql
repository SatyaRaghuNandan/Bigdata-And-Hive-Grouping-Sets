use tmp_sbu_pkgquerydb;
create table tmp_dhua_test_data1 as 
select explode(array('1','2','Abc','DEF','ghi','中文')) as s
;


insert into table tmp_dhua_test_data1
select s from (
select explode(array('1:2\\;3:4','中文:中')) as s) a
;


insert into table tmp_dhua_test_data1
select s from (
select explode(array('{"a":"a,b,c","bcd":["中文","中"]}')) as s) a
;



select * from tmp_dhua_test_data1;


