# https://docs.google.com/spreadsheets/d/13XC6_-GpTlZXb14yQuGraJ2VYOu_LPhbEr1sK-fvvKc/edit?resourcekey=&gid=1800162009#gid=1800162009
# https://docs.google.com/spreadsheets/d/13XC6_-GpTlZXb14yQuGraJ2VYOu_LPhbEr1sK-fvvKc/edit?usp=sharing

#import pandas as pd
#url='https://docs.google.com/spreadsheets/d/13XC6_-GpTlZXb14yQuGraJ2VYOu_LPhbEr1sK-fvvKc/edit?usp=sharing'
#path = 'https://drive.google.com/uc?export=download&id='+url.split('/')[-2]
#df = pd.read_csv(path)

import os
import requests
import sys

def getGoogleSeet(spreadsheet_id, outDir, outFile):
  url = f'https://docs.google.com/spreadsheets/d/{spreadsheet_id}/export?format=csv'
  response = requests.get(url)
  if response.status_code == 200:
    filepath = os.path.join(outDir, outFile)
    with open(filepath, 'wb') as f:
      f.write(response.content)
      print('CSV file saved to: {}'.format(filepath))    
  else:
    print(f'Error downloading Google Sheet: {response.status_code}')
    sys.exit(1)


outDir = 'data/'

os.makedirs(outDir, exist_ok = True)
filepath = getGoogleSeet('13XC6_-GpTlZXb14yQuGraJ2VYOu_LPhbEr1sK-fvvKc', outDir, "answers.csv")

sys.exit(0); ## success