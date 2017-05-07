import io,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding='utf8')

import pandas as pd
import numpy as np

fpath=r'D:\Users\dhua\day\works\assets\data\dim'

fsrc=fpath+r"\DimFlt_AirPort.txt"

print(fsrc)

df=pd.read_csv(fsrc,encoding='utf_8_sig',sep='\t')
print(df.count())
print(df.dtypes)
print(df.head())

# names=['ProvinceId', 'ProvinceName', 'ProvinceEname','CountryId']
names=['CityId', 'CityCode', 'CityName','CityEname','ProvinceId','ProvinceName','CountryId','CountryName','AreaName']
print(names)

df=pd.read_csv(fsrc,encoding='utf_8_sig',sep='\t',names=names,header=0)



print(np.unique(df['CountryName'].values))

print(df['AreaName'].unique())

print(df[df['AreaName'].isnull()]['AreaName'].values.unique())

print(np.unique((df[df['AreaName'].isnull()]['AreaName']).values))

# 列重排
df=df[['Code','ChsName','EngName']]


# 重命名
df.rename(columns={'原列名' : '新列名'}) 
df = df.rename(columns={'ChsName' : 'Name','EngName':'Ename'})

# 填充缺失值
df[df['MgrGroup'].isnull()]
df['MgrGroup'] = df['MgrGroup'].fillna(0)

df['ContinentId'] = df['ContinentId'].fillna(0)
# 转化类型
df[['MgrGroup']] = df[['MgrGroup']].astype(np.int64)
df[['ContinentId']] = df[['ContinentId']].astype(np.uint8)

print(df.head())
print(df.describe())

print(df[df.CountryId==171])

print(df.count())


# print(bbb.head())

# c=bb.to_json(orient="records",force_ascii =False)

# bb.to_json()

# print(type(c))

# b.to_pickle('foo.pkl')




# sql
# pip install sqlalchemy
# pip install SQLAlchemy-1.1.6.tar.gz
from sqlalchemy import create_engine
# engine = create_engine('sqlite:///:memory:')
engine = create_engine('sqlite:///dim.db')

with engine.connect() as conn, conn.begin():
    df.to_sql('flightairport', engine,index=False)



 
