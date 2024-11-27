import os
import requests
import sys
from io import StringIO
import csv

def getGoogleSheet(spreadsheet_id, outDir, outFile, exclude_columns=None):
    url = f'https://docs.google.com/spreadsheets/d/{spreadsheet_id}/export?format=csv'
    response = requests.get(url)
    if response.status_code == 200:
        filepath = os.path.join(outDir, outFile)
        raw_csv = response.content.decode('utf-8')
        
        if exclude_columns:
           
            input_csv = StringIO(raw_csv)
            reader = csv.DictReader(input_csv)
            
            with open(filepath, 'w', encoding='utf-8', newline='') as output_file:
                writer = csv.DictWriter(
                    output_file, 
                    fieldnames=[col for col in reader.fieldnames if col not in exclude_columns]
                )
                writer.writeheader()
                for row in reader:
                    writer.writerow({k: v for k, v in row.items() if k not in exclude_columns})
        else:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(raw_csv)
        
        print('Cleaned CSV file saved to: {}'.format(filepath))
    else:
        print(f'Error downloading Google Sheet: {response.status_code}')
        sys.exit(1)

spreadsheet_id = '13XC6_-GpTlZXb14yQuGraJ2VYOu_LPhbEr1sK-fvvKc'
outDir = 'data/'
outFile = "answers.csv"
exclude_columns = ['E-adresa']

os.makedirs(outDir, exist_ok=True)

getGoogleSheet(spreadsheet_id, outDir, outFile, exclude_columns)

sys.exit(0)
