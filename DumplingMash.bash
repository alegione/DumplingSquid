#!/bin/bash

# check number of processors
cpus=$(nproc)

# Set working directory from input
if [ -z $1 ]; then
  Dir=$1
  cd $Dir
else
  echo "Working directory must be provided"
  exit
fi

if [ -z $2 ]; then
  echo "Read directory provided at $2"
  cat $2/*R1.fastq >> Merged_reads_R1.fastq
  zcat $2/*R1.fastq.gz >> Merged_reads_R1.fastq
else
  echo "Read directory must be provided"
  exit
fi

# check if the reference file is provided
if [ -z $3 ]; then
  Reference=$3
else
  wget https://gembox.cbcb.umd.edu/mash/refseq.genomes%2Bplasmid.k21s1000.msh
  Reference="refseq.genomes%2Bplasmid.k21s1000.msh"
fi



mash screen -w -p $cpus $Reference Merged_reads_R1.fastq > "$Dir/screen.tab"

# -w is for 'winner takes all' to reduce redundancy
# -p is for threads (change for scaling)

sort -g -r screen.tab | cut -f 5 > genomes2download.txt
# pull out just the genomes

echo -e "Mash complete"
