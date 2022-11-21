import pandas as pd


data1 = pd.read_csv("/Users/leandrojorqueravalero/Desktop/PhD/Miseq/NGS_code/seqs_file", sep='\t')
df1 = pd.DataFrame(data1)

data2 = pd.read_csv("/Users/leandrojorqueravalero/Desktop/PhD/Miseq/NGS_code/ID", sep='\t')
df2 = pd.DataFrame(data2)

df_final = df1.join(df2,lsuffix="_caller", rsuffix="_other")
df_final.columns = ['name','fastq_r1']

print(df_final)





