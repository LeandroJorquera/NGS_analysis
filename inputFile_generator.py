import os
import pandas as pd
import numpy as np
import re
#-- path where reads are stored
path = "/Users/leandrojorqueravalero/Desktop/PhD/Miseq/Miseq_optimization"
#-- loop for creating file names and abbreviations
header = ['name','fastq_r1']
list_fastq = []
list_name = []
for file in os.listdir(path):
    #only fastq.gz files and generate abbreviated names (ID)
    if file.endswith(".fastq.gz"):
        list_fastq.append(file)
        short = re.split("[_S]",file)[0]
        list_name.append(short)
#print(list_name)
#print(list_ID)
#--turning results into dataframe
dict = {'name':list_name,'fastq_r1':list_fastq}
df = pd.DataFrame(dict)
df.columns = ['name','fastq_r1']
print(df)
#--saving the file
df.to_csv("input_file", sep="\t", index=False)









