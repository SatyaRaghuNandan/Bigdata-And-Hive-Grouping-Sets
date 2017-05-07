import pandas as pd

from kits.txtfileop import printheadbyte, gettxtatline,counttxtlines

srcfilepath = r"D:\Users\dhua\day\works\assets\data"

srcfile = srcfilepath + r'\pkg\pkgorderuid170310.txt'

srcfile = srcfilepath + r'\pkg\pkgpassengers.txt'

print(srcfile)

# print(counttxtlines(srcfile))

printheadbyte(srcfile)

# dataid = pd.read_csv(srcfile, encoding='utf_8_sig',sep='\t',dtype=object)

# print(dataid.dtypes)

# print(dataid.head(5))

# dataid.to_pickle('foo.pkl')