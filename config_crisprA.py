import os
import re
import configparser

#-- VARIABLES TO CHANGE
input_path = "/Users/leandrojorqueravalero/Desktop/PhD/Miseq/Miseq_optimization/"
output_path = "/Users/leandrojorqueravalero/Desktop/PhD/Miseq/Miseq_optimization/"
amplicon_path = "/Users/leandrojorqueravalero/Desktop/PhD/Miseq/amplicon_seqs/*emx1*"

#-- Loop for generating multisample lists
list_name = []
for file in os.listdir(input_path):
    if file.endswith(".fastq.gz"):
        short = re.split("[_S]",file)[0]
        list_name.append(short)
print(list_name)


#--Create config object and pass it to 'config'
config = configparser.ConfigParser()
#--Add structure to the config file we will create
config.add_section('input/output')
config.set('input/output','outDir',f"{output_path!r}")
config.set('input/output','input',f"{input_path!r}")
#---
config.add_section('settings')
config.set('settings','r2file','true')
config.set('settings','inSize','-1')
config.set('settings','umiClustering','false')
config.set('settings','umiType','"TV"')
config.set('settings','minlen','55')
config.set('settings','maxlen','57')
config.set('settings','id','0.99')
config.set('settings','ubs','1')
config.set('settings','error','1')
config.set('settings','simGE','false')
config.set('settings','simGEfilesPath','"./bin/SimGE"')
config.set('settings','simGEid','"sample_0"')
config.set('settings','simGEsequence','""')
config.set('settings','cutSite','""')
config.set('settings','aligner','"minimap2"')
config.set('settings','mock','false')
config.set('settings','template','false')
config.set('settings','spike','"no"')
#---
config.add_section('seqs')
config.set('seqs','referenceFasta',f"{amplicon_path!r}") # add path for fasta sequence of the amplicon
config.set('seqs','indexHuman','"./Genomes/Human"') # path for human genome sequence location
config.set('seqs','indexMouse','"./Genomes/Mouse"') # path for mouse genome sequence location
config.set('seqs','refOrganism','[["sample_0", "other"]]') # add reference organism for each sample
config.set('seqs','gRNAseq','[["sample_0", "GGGGCCACTAGGGACAGGAT"]]') # add gRNA sequence for each sample
config.set('seqs','selfRef','[["sample_0", false ]]') #
config.set('seqs','template_seq','"./Testing-example/Template-hdr/*"') # add template seq (or desired edit in PE) for each sample
config.set('seqs','samplesNames_file','"samples.php"') # add file with sample names
config.set('seqs','protCutSite','[["sample_0", -3 ]]') # add protospacer cut site (-3 for Cas9) for each sample
#---
config.add_section('docker_settings')
config.set('docker_settings','process.container','"msanvicente/crisprgareq"')
config.set('docker_settings','docker.enabled','false')
config.set('docker_settings','singularity.enabled','true')
config.set('docker_settings','singularity.autoMounts','true')

#--Write the out config file
#with open("/Users/leandrojorqueravalero/PycharmProjects/pythonProject/NGS_analysis/crisprA.config", 'w') as configfile:
    #config.write(configfile)
























