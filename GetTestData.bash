#!/bin/bash

# Mash screen example from https://mash.readthedocs.io/en/latest/tutorials.html
# need to download mash database first:

while read prompt; do
  echo -e "Please enter a number between 1 - 3 to decide what to download for Dumpling Squid"
  echo -e "\t1) RefSeq database plus plasmids for mash alignment"
  echo -e "\t2) RefSeq database only for mash alignment"
  echo -e "\t3) Example fastq file for mash alignment (for testing only)"
  case $prompt in
    1)
    echo -e "downloading the refseq mash database with plasmids"
    wget -c https://gembox.cbcb.umd.edu/mash/refseq.genomes%2Bplasmid.k21s1000.msh
    ;;
    2)
    echo -e "downloading the refseq mash database"
    wget -c https://gembox.cbcb.umd.edu/mash/refseq.genomes.k21s1000.msh
    ;;
    3)
    echo -e "Downloading some test/example data"
    fastq-dump --gzip --split-files ERR024951
    ;;
    *)
    echo -e "You don't appear to have picked a number between 1 - 3?"
    ;;
  esac
