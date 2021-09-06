import pandas as pd
sheets = pd.read_excel('Data of Final Assignment for Data Basics.xlsx',sheet_name=None)
for sheet in sheets.keys():
    sheets[sheet].to_csv(f'{sheet}.csv',index=False,encoding='utf-8')
    
