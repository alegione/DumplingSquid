#!/usr/bin/env nextflow

params.reads      = "/data/reads/*_R{1,2}.fastq.gz"
params.results    = "results"


log.info """\
D U M P L I N G S Q U I D   V0.1
================================

reads    : $params.reads
results  : $params.results
"""

reads_ch  = Channel.fromFilePairs(params.reads)

process 'Mash_screen' {
  input:
      reads


  shell:
    dumplingMash.bash $(pwd) reads reference
}

# take first 3, 5-7, 8-10, 11-13, trim after third underscore and add all to end
sort -g -r screen.tab | cut -f 5 | grep -v 'ref' | while read ref; do echo "ftp://ftp.ncbi.nlm.nih.gov/genomes/all/${ref:0:3}/${ref:4:3}/${ref:7:3}/${ref:10:3}/$(echo $ref | cut -d _ -f 1-3)/$ref" >> downloads.txt; done

date > log.txt; cat downloads.txt | parallel --gnu "echo {}; wget {} 2>&1 | grep -i 'failed\|error' >> log.txt";
# took 30 minutes, generated ~5 GB of data in 3527 genomes

# add plasmids (Stored with different accession)
cut -f 5 screen.tab | grep 'ref' | awk 'BEGIN { FS = "|" }; {print $2}' | parallel -j 8 --gnu "esearch -db nucleotide -query {} | efetch -format fasta > database/{}.fasta"
# (technically this downloads both plasmid and non-plasmid seqeuence from the same accession, ideally would be plasmid only, could grep -A if plasmid in header of all and single line fasta?)

# add genomes to kraken2 database, either remove intermediate files, or keep at least the gzip files
basename -s '.fna.gz' *.fna.gz | parallel -j 8 --gnu "gunzip {}.fna.gz; kraken2-build --add-to-libary {}.fna --db ../dumplinglib; rm {}.fna; rm {}.fna.gz"
basename -s '.fna.gz' *.fna.gz | parallel -j 8 --gnu "gunzip {}.fna.gz; kraken2-build --add-to-libary {}.fna --db ../dumplinglib; rm {}.fna"

# add the plasmid containing sequences to the database (technically this adds both plasmid seqeuences and non-plasmid from the same accession, ideally would be plasmid only)
basename -s '.fasta' *.fasta | parallel -j 8 --gnu "kraken2-build --add-to-libary {}.fasta --db ../dumplinglib"

# May need to also download the taxonomy info from NCBI as per kraken2 info
kraken2-build --download-taxonomy --threads 8 --db ../dumplinglib
#generates 30 gb of data...quite a lot

kraken2-build --build --threads 8 --db ../dumplinglib
# takes 30 mins, builds 20 gb database

kraken2 --db dumplinglib ERR024951.fastq --threads 8 > mashtest.kraken.out
# ran on 8 cpu 32 gb machine
# took approximately 4 minutes

retaxdump

rcf -n ./taxdump -k mashtest.kraken.out -s KRAKEN


### metamaps possibly better than kraken?
