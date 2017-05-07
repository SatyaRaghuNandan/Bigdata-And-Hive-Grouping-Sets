import io,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding='utf8')

from kits.txtfileop import *

import json

fpath= 'D:\\Users\\dhua\\day\\works\\assets\\image\\imagenov\\'

fname= '28.json'


def changefile():
    fsrc=fpath + fname

    # printheadbyte(fsrc)

    with open(fsrc,encoding='utf-8') as f:
        jo=json.load(f)

    # print(type(jo))
    # print(jo.keys())

    log=jo['log']

    # print(type(log))
    # print(log.keys())

    # print(log['version'])
    # print(log['creator'])
    # print(log['pages'])

    entries=log['entries']

    # print(type(entries))
    # print(len(entries))

    imgitems=[]

    ii=0
    for entry in entries :
        text=entry['response']['content']['text']
        # print(type(text))
        # if(ii==1):
            
        #     print(text[0:10])
        #     print('--------------')
        #     jtext=json.loads(text)
            # continue

        # print(text)
        jtext=json.loads(text)
        items = jtext['Data']['Items']
        # # print(type(items))
        imgitems.extend(items)
        # print(type(items[0]))
        # print(items[0].keys())
        # print(items[0])
        # break
        # ii=ii+1
        # print(ii)
        # if(ii>2):
        #     # break
        #     pass

    print(len(imgitems))


# import pandas as pd



# fname2='do_'+fname

# with open(fname2,'w') as f:
#     json.dump(imgitems,f)

# a=entries[0]
# print(type(a))
# print(a.keys())

# response=a['response']['content']

# print(response.keys())

# text=response['text']

# print(type(text))

# jtext=json.loads(text)
# print(type(jtext))

# print(jtext.keys())

# items = jtext['Data']['Items']
# print(type(items))
# print(type(items[0]))
# print(items[0].keys())
# print(items[0])

# print(a['time'])
# print(a['connection'])

# f=open('a.json','w')
# json.dump(a,f)

# with open('a.json','w') as f:
#     json.dump(response,f)

# b=a['entries']

# print(b[0])


# import json
# f='a.json'

# with open(f,encoding='utf-8') as f2:
#     a=json.load(f2)

# with open(f) as f2:
#     a=json.load(f2)
# print(type(a))

# import pandas as pd

# b=pd.DataFrame(a)