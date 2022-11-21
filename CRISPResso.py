import os
import pandas as pd
path = "/Users/leandrojorqueravalero/Desktop/PhD/Miseq/Miseq_optimization"
#list directory
for file in os.listdir(path):
    #only fastq.gz files
    if file.endswith(".fastq.gz"):
        print(file)




#data1 = pd.read_csv("/Users/leandrojorqueravalero/Desktop/PhD/Miseq/Miseq_optimization", sep='\t')

#data2 = pd.read_csv("/Users/leandrojorqueravalero/Desktop/PhD/Miseq/", sep='\t')
#df2 = pd.DataFrame(data2)

#df_final = df1.join(df2,lsuffix="_caller", rsuffix="_other")
#df_final.columns = ['name','fastq_r1']

#print(df_final)
#data1 = pd.read_csv("/Users/leandrojorqueravalero/Desktop/PhD/Miseq/Miseq_optimization/editing_ouput.txt", sep='\t')
#df1 = pd.DataFrame(data1)
#print(df1)








