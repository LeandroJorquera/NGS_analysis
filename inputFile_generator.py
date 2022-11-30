import os
import pandas as pd
import numpy as np
import re

#-- path where reads are in my marvin folder
path = "/homes/users/ljorquera/scratch/data/Miseq_optimization"

#-- loop for creating file names and abbreviations
list_fastq = []
list_fastq2 = []
list_name = []

for file in os.listdir(path):
    #only fastq.gz files and generate abbreviated names
    if file.endswith(".fastq.gz"):
        if filenmatch:
            list_fastq.append(file)
        #if file.find("R2"):
            #list_fastq2.append(file)
        short = re.split("[_S]",file)[0]
        list_name.append(short)
print(list_name)
print(list_fastq)

#--turning results into dataframe
dict = {'name':list_name,'fastq_r1':list_fastq, 'fastq_r2':list_fastq2}
df = pd.DataFrame(dict)
df.columns = ['name','fastq_r1','fastq_r2']
# remove duplicates
df = df.drop_duplicates(subset ='name')
#print(df)

#--saving the file
#df.to_csv("input_file", sep="\t", index=False)








