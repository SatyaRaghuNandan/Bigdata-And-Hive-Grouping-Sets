import pandas as pd



from kits.txtfileop import printheadbyte, gettxtatline

srcfilepath = r"D:\Users\dhua\day\works\assets\data\2017m3\id"

srcfile = srcfilepath + "\\" + r'20170301.csv'

# printheadbyte(srcfile)

dataid = pd.read_csv(srcfile, encoding='utf_8_sig',sep=',',dtype=object)

print(dataid.dtypes)

print(dataid.head(5))

dataid.to_pickle('foo.pkl')
# dataid.append

import pandas as pd
a=pd.read_pickle('foo.pkl')
print(a.head(500))
