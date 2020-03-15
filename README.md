# DumplingSquid
Classify metagenomic reads based on miniture kraken2 databases


Workflow based on a Mick Watson musing on twitter: https://twitter.com/BioMickWatson/status/1224983069490339840

Currently just playing around with ideas

# programs used:

mash
sratoolkit (only for getting example files)
wget
parallel
edirect
kraken2
python3
recentrifuge
pandas
openpyxl
xlrd
matplotlib

# Mick's thoughts from https://twitter.com/BioMickWatson/status/1224983069490339840
#1) upload metagenomics reads to NCBI
#2) Mash screen automatically tells me which genomes are in my reads
#3) Automatic bulk download of those genomes
#4) Build (for example) Kraken DB from them
#5) Taxonomic profile of reads
