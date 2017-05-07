import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from txtfileop import printheadbyte,gettxtatline

f='a.csv'
f='a.txt'

printheadbyte(f)
# gettxtatline(f,235562)
# gettxtatline(f,28373)
# gettxtatline(f,28374)

# mydtype={'MobileNumber':np.int64,'PaySuccTime':object,'MerchantName':object,'SummaryAmount':np.float,'UID':object}
# mydtype={'MobileNumber':object,'PaySuccTime':object,'MerchantName':object,'SummaryAmount':np.float,'UID':object}
# b=pd.read_csv(f,dtype=mydtype,encoding='utf_8_sig',error_bad_lines=False)
# b=pd.read_csv(f,encoding='utf_8_sig',quotechar='"',nrows=37)

# b=pd.read_csv(f,encoding='utf_8_sig',dtype=mydtype)
b=pd.read_csv(f,encoding='utf_8_sig')
b=pd.read_csv(f,encoding='utf_8_sig',sep='\t')

b.to_csv(f,encoding='utf_8',index=False)

c=b.copy()

b.drop(['email'], inplace=True,axis=1)

c=b.copy()



b["pkgid"]=b["pkgid"].fillna(0.0).astype(np.int64)

fillna(0.0).astype(int)

b.loc[150221]

b.loc[529000]

b.loc[b.pkgid.isnull(),'pkgid']
b.loc[b.pkgid.isnull(),'pkgid']='0'
b["pkgid"]=b["pkgid"].astype(np.int64)

b.orderid

b.loc[b.orderid.isnull(),'orderid']
b.loc[b.pkgid.isnull(),'pkgid']='0'


b["orderid"]=b["orderid"].astype(np.int64)


f2='pkgorder_11.csv'
f2='dimpkg_11.csv'
f2='pkgprovider_11.csv'
f2='pkgclient_11.csv'

f2='pkgresourceid_11.csv'
f2='resource_11.csv'

b.to_csv(f2,encoding='utf_8',index=False)



print(b.head(5))

c[c.provider==14]



f2='pkgresourceid.csv'

b.rename(columns={"pkg":"pkgid"},inplace=True)

b.to_csv(f2,encoding='utf_8',index=False)

c=pd.read_csv(f2)

c1=c[1:2]

c1.at[1,'contactname']='adsf,"abc'
c1.to_csv('c1.csv',encoding='utf_8',index=False)

c2=pd.read_csv('c1.csv')

