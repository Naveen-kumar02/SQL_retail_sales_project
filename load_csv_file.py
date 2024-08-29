#import libraries 
import pandas as pd 
from sqlalchemy import create_engine 

#connecting sql workbench
conn_string = create_engine('mysql+mysqlconnector://root:Naveenk02@localhost/sqlproject')
conn = conn_string.connect()

df=pd.read_csv('/Users/naveenkumar/Desktop/Retail-Sales-Analysis-SQL-Project--P1/SQL - Retail Sales Analysis_utf .csv')
df.to_sql('retail_sales',con=conn,if_exists='replace',index=False) 
print('the data is loaded successfully into the mysql workbench')