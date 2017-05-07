-- 将python文件加载到系统
add FILE weekday_mapper.py;
-- 将数据按周进行分割
INSERT OVERWRITE TABLE u_data_new
SELECT
TRANSFORM (userid, movieid, rating, unixtime)
USING 'python weekday_mapper.py'
AS (userid, movieid, rating, weekday)
FROM u_data;

#用python编写用于查找最高气温的reduce函数
cat sample.txt | max_temperature_map.py | sort |

[weekday_mapper.py]
import sys
import datetime
 
for line in sys.stdin:
  line = line.strip()
  userid, unixtime = line.split('\t')
  weekday = datetime.datetime.fromtimestamp(float(unixtime)).isoweekday()
  print ','.join([userid, str(weekday)])

[myre.py]
import sys
import re
for line in sys.stdin:
    line = line.strip()
    pattern=r',([\w\x80-\xff]+):'
    print re.sub(pattern,r'&\1:',line)

[hive]
add FILE /home/sbupkg/dhua/python/myre.py;
list FILES;
select TRANSFORM('asdf&bcc:cde,asdlfjk,b_中文:asdf')  using 'python myre.py' as  a;

pattern=r',([\w\u4e00-\u9fa5]+):'
line='asdf&bcc:cde,asdlfjk,b:asdf'
line2='asdf&bcc:cde,asdlfjk,b_中文:asdf'
re.sub(pattern,r'&\1:',line)


cat 'asdf,bcc:cde,asdlfjk,b_中文:asdf' | python myre.py

SELECT TRANSFORM(pv_users.userid, pv_users.date) USING 'map_script' AS dt, uid CLUSTER BY dt FROM pv_users;


-- 如果要用查询的嵌套形式，我们可以指定map和reduce函数。

From (
   From record2
   Map year, temperature, quality
   Using ‘is_good_quality.py’
   As year, temperature ) map_output
Reduce year, temperature
Using ‘max_temperature_reduce.py’
As year, temperature;
