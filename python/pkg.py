import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 度假订单
fpkgorder='pkgorder_11.csv'
pkgorder=pd.read_csv(fpkgorder,encoding='utf_8')
pkgorder.info()

x=pkgorder[['orderdate']]

# 度假产品
fdimpkg='dimpkg.csv'
dimpkg=pd.read_csv(fdimpkg,encoding='utf_8')
dimpkg.info()


# 度假供应商
fpkgprovider='pkgprovider.csv'
pkgprovider=pd.read_csv(fpkgprovider,encoding='utf_8')
pkgprovider.info()



# 度假客户
fpkclient='pkgclient.csv'
pkgclient=pd.read_csv(fpkclient,encoding='utf_8')
pkgclient.info()




#度假维表
fdimpkg_productcategory='dimpkg_productcategory.txt'
dimpkg_productcategory=pd.read_csv(fdimpkg_productcategory,encoding='utf_8',sep='\t')
dimpkg_productcategory.info()

fdimpkg_productpattern='dimpkg_productpattern.txt'
dimpkg_productpattern=pd.read_csv(fdimpkg_productpattern,encoding='utf_8',sep='\t')
dimpkg_productpattern.info()

# 
grouped = pkgorder.groupby('productcategoryname')
grouped = pkgorder.groupby('productpatternname')
grouped = pkgorder.groupby(['productcategoryname','productpatternname'])
grouped.size()
grouped['orderid'].count()
grouped['orderid'].agg([np.size])
grouped.size().reset_index()

#youxue
youxue=pkgorder[pkgorder.productcategoryname.str.match('.*游学.*')]
grouped2 = youxue.groupby('productcategoryname')
youxue2=pd.merge(pd.merge(youxue,dimpkg[['pkgid','vendorid','vendorid_src']],on='pkgid'),pkgprovider[['provider','providername']],left_on='vendorid_src',right_on='provider')
youxue2.to_csv('merge.csv',encoding='utf_8',index=False)


pd.merge(df1, df2, on='col1', how='outer', indicator=True)

Merge method	SQL Join Name	Description
left	LEFT OUTER JOIN	Use keys from left frame only
right	RIGHT OUTER JOIN	Use keys from right frame only
outer	FULL OUTER JOIN	Use union of keys from both frames
inner	INNER JOIN	Use intersection of keys from both frames

Observation Origin	_merge value
Merge key only in 'left' frame	left_only
Merge key only in 'right' frame	right_only
Merge key in both frames	both