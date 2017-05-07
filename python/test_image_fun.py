import io,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding='utf8')

from kits.txtfileop import *

import json

def changefile(fsrc,fdest):
    with open(fsrc,encoding='utf-8') as f:
        jo=json.load(f)

    entries=jo['log']['entries']
    imgitems=[]

    for entry in entries :
        # print(entry['response']['content'].keys())

        if("encoding" in entry['response']['content'].keys()):
            print(entry['response']['content'])
            continue

        if("text" not in entry['response']['content'].keys()):
            print(entry['response']['content'])
            continue

        text=entry['response']['content']['text']
        jtext=json.loads(text)
        items = jtext['Data']['Items']
        for item in items:
            if("ImageSizeList" in item.keys()):
                del item["ImageSizeList"]
            imgitems.append(item)

    print(len(imgitems))

    with open(fdest,'w') as f:
        json.dump(imgitems,f)


# a={'a':1,'b':2}

fpath= 'D:\\Users\\dhua\\day\\works\\assets\\image\\imagenov\\'

# for i in range(1,34):
#     fname= '{}.json'.format(i)

#     fsrc=fpath + fname
#     fdes=fname

#     # print(fsrc)
#     print(fdes)
#     changefile(fsrc,fdes)

items=[]

k=0

# for i in range(1,34):
#     fname= '{}.json'.format(i)
#     fdes=fname
#     print(fdes)

#     with open(fdes,'r') as f:
#         item = json.load(f)
#         k+=len(item)
#         # items.extend(item)

# print(k)

# with open('noversion.json','w') as f2:
#     json.dump(items,f2)



df.loc[0:3,['Description','PoiName']]

with open('noversion.json','r') as f:
    image = json.load(f)

print(len(item))

import json
f=open('noversion.json','r')
images = json.load(f)

df=pd.DataFrame(images)
df.to_pickle('image_v.pkl')

import pandas as pd
df=pd.DataFrame(images)
df.to_pickle('image.pkl')



import pandas as pd
df=pd.read_pkckle('image.pkg')
df1=pd.read_pickle(r'D:\git\scripts\python\image_nov.pkl')
df2=pd.read_pickle(r'D:\git\scripts\python\image_v.pkl')

df=df1.append(df2)

df.info()

df1.dtypes
df1.count()
df2.dtypes
df1.columns
df2.columns


df['Authorize'].value_counts()

df['Active'].unique()
# array([None], dtype=object)
df.pop('Active')

df['Authorize'].unique()
# array(['有'], dtype=object)
# df.pop('Authorize')

df['CityID'].unique()
# array([0], dtype=int64)
df.pop('CityID')

df['CountryID'].unique()
df['CountryName'].unique()


df['CreateTime'].unique()
df.pop('CreateTime')

df['CreateUser'].unique()
df.pop('CreateUser')

df['Description'].unique()
df['DistrictID'].unique()
df['DistrictName'].unique()
df['FileName'].unique()
df.pop('FileName')

df['Guid'].unique()
df.pop('Guid')

df['ID'].unique()

df['ImageClass'].unique()
# array(['旅游产品'], dtype=object)
df.pop('ImageClass')

df['ImageID'].unique()
df.pop('ImageID')

df['ImageSourceName'].unique()

df['ImageUrl'].unique()
df['ImageUrl_500_280'].unique()
df.pop('ImageUrl_500_280')

df['IsSelected'].unique()
df.pop('IsSelected')

df['JobNum'].unique()
df.pop('JobNum')

df['LicensePath'].unique()
df.pop('LicensePath')

df['ModifyTime'].unique()
df.pop('ModifyTime')

df['ModifyUser'].unique()
df.pop('ModifyUser')

df['NewBigBigImageUrl'].unique()
# df.pop('xxx')

df['NewBigImageUrl'].unique()
df.pop('NewBigImageUrl')

df['NewImageID'].unique()
df.pop('NewImageID')

df['NewSmallImageUrl'].unique()
df.pop('NewSmallImageUrl')

df['PoiId'].unique()
# df.pop('xxx')

df['PoiName'].unique()
# df.pop('xxx')

df['Provider'].unique()
# df.pop('xxx')

df['ScenicSpot'].unique()
# df.pop('xxx')

df['Season'].unique()
# df.pop('xxx')

df['SmallImageUrl'].unique()
df.pop('SmallImageUrl')

df['XML'].unique()
# array([None], dtype=object)
df.pop('XML')

df.dtypes

df=df[['ID','Authorize','Provider','CountryID', 'CountryName',  'DistrictID', 'DistrictName','PoiId','PoiName',
'ScenicSpot', 'Season', 'Description','ImageSourceName', 'ImageUrl', 'NewBigBigImageUrl']]

df.to_pickle('image_new.pkl')

df.head(1)

df.head().to_csv('a.csv')

df.columns
