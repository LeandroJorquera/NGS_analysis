import os
import pandas as pd
import fnmatch
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
        if fnmatch.fnmatch(file,"*R1*"):
            list_fastq.append(file)
        else:
            list_fastq2.append(file)
        short = re.split("[_S]", file)[0]
        list_name.append(short)
# remove duplicates from name list and order all lists
names = []
for i in list_name:
    if i not in names:
        names.append((i))
#names.sort()
#list_fastq.sort()
#list_fastq2.sort()

names.sort(key=lambda x: x.split("-") sum(x[0] + x[1]))
print(names)

#--Including results into dataframe
#dict = {'name':names, 'fastq_r1':list_fastq, 'fastq_r2':list_fastq2}
#df = pd.DataFrame(dict)
#print(df)

#--saving the file
#df.to_csv("input_file", sep="\t", index=False)








