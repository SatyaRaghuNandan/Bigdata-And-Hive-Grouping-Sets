import io,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding='utf8')

from kits.txtfileop import *
printheadbyte(fname)

import json
fname='1-100.json'
with open(fname,encoding='utf-8') as f:
    jo=json.load(f)


type(jo)
jo.keys()

a=jo['log']
b=a['entries']

items=[]
for i in range(1,51):
    f=str(i)+".txt"
    f1=open(f,encoding='utf-8')
    jo=json.load(f1)
    item=jo['Data']['Items']
    items.extend(item)
    
ofile='items1.json'
with open(ofile,'w',encoding='utf-8') as outf:
    json.dump(items,outf)
    

for i in range(2,7):
    items=[]
    fname=str(i)+".json"
    with open(fname,encoding='utf-8') as f:
        jo=json.load(f)

    for j in range(0,len(jo['log']['entries'])):
        s=jo['log']['entries'][j]['response']['content']['text']
        jo2=json.loads(s)
        item=jo2['Data']['Items']
        items.extend(item)
        
    oname='items'+str(i)+".json"
    with open(oname,'w',encoding='utf-8') as outf:
        json.dump(items,outf)  
        

items=[]
for i in range(1,7):
    fin = 'items'+str(i)+".json"
    with open(fin,encoding='utf-8') as f:
        jo=json.load(f)
    items.extend(jo)

fout='image.json'
with open(fout,'w',encoding='utf-8') as outf:
    json.dump(items,outf)  


