import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


s = pd.Series([1,3,5,np.nan,6,8])
s = pd.Series(np.random.randn(5))

dates = pd.date_range('20130101', periods=6)
df = pd.DataFrame(np.random.randn(6,4), index=dates, columns=list('ABCD'))

s.index
df.dtypes

s = pd.Series(np.random.randn(5), index=['a', 'b', 'c', 'd', 'e'])


f='D:\\ctrpdata\\兑换话费.csv'
mydtype={'MobileNumber':np.int64,'PaySuccTime':object,'MerchantName':object,'SummaryAmount':np.float,'UID':object}
mydtype={'MobileNumber':object,'PaySuccTime':object,'MerchantName':object,'SummaryAmount':np.float,'UID':object}
b=pd.read_csv(f,dtype=mydtype,encoding='utf_8_sig',error_bad_lines=False)
b=pd.read_csv(f,encoding='utf_8_sig')

b=pd.read_csv(f,dtype={'MobileNumber':np.int64,'PaySuccTime':object,'MerchantName':object,'SummaryAmount':np.float,'UID':object},encoding='utf_8_sig')


b.rename(columns={"MobileNumber":"mobile","UID":"uid"},inplace=True)

b.drop(['PaySuccTime'],axis=1,inplace=True)

b.drop(b.mobile.isnull(),inplace=True)

b[b.mobile.isnull()]

b.mobile.astype('int64')

c=b.groupby(['uid','mobile'])

b.info()

f.reset_index()

b[b[]]

str
lower()
upper()
len()
strip(),lstrip(),rstrip()
split(','),split('_', expand=True),split('_').str.get(1),split('_').str[1]
replace('^.a|dog', 'XX-XX ', case=False)