import io,sys
import sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding='utf8')

import pandas as pd

b=pd.read_pickle('foo.pkl')

print(b.head(10))
