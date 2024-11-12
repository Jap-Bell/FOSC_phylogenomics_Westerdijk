#!/bin/bash

# I want this script to take an assembly as input ($1), build a database from this with a given name structure, blast the 6 Sanga+Kali genes on it, and view the output

strain_name=$(echo "$1" | rev | cut -d "/" -f1 | rev | cut -d "." -f1)
suffix=$(echo "$1" | rev | cut -d "." -f1 | rev)
input_file="$1"
echo "Input file is: $1"
echo "Strain name is: $strain_name"

#Check if output folder already exists, if so exit the script (to prevent re-running from files that have already been done)
if test -d ~/h/BLAST/SangaKali_Blast/"$strain_name"_res/; then
	echo "$strain_name BLAST has already been done, skipped here"
	exit
fi


## Should implement a check here if the sequence is still gzipped  (and subsequently unzip it)
if [[ "$suffix" == "gz" ]]
then
	gunzip "$1"
	input_file=$(echo "$1" | rev | cut -d "." -f2,3,4,5,6,7 | rev) 
fi



#OLD makeblastdb command
##makeblastdb -in - -dbtype nucl -parse_seqids -blastdb_version 5 -out "$HOME/h/BLAST/databases/$strain_name" -title "$strain_name"

mkdir ~/h/BLAST/SangaKali_Blast/"$strain_name"_res/
for gene in ~/h/BLAST/SangaKali_Blast/*_genes/*.fasta
	do
	gene_name=$(echo "$gene" | rev | cut -d "/" -f 1 | rev | cut -d "." -f1)
	touch ~/h/BLAST/SangaKali_Blast/"$strain_name"_res/"$gene_name"."$strain_name".out
	blastn -subject "$input_file" -query "$gene" -out ~/h/BLAST/SangaKali_Blast/"$strain_name"_res/"$gene_name"."$strain_name".out 
	done
