#!/bin/bash

#Script that finds: the number of contigs, total sequence length, GC_content, N50, L50, number of telomeres and
#number of telomere matches (2 telomeres on opposite ends of a contig)
#outputs to a file called ~/sequence_info.csv

#Required inputs: 1. FASTA-file, 2. TeloVision _info.tsv file
#Dependencies: ~/scripts/N50_calculator.py, ~/scripts/L50_calculator.py, ~/scripts/telomere_counter.py
#	       ~/scripts/tel_name_parser

seq_name=$(echo "$1" |cut -d "/" -f 3 | cut -d "." -f 1) #Cuts the name of the german sequences shorter
telo_file=$(~/scripts/telo_name_parser.sh "$1")

if ! test -f ~/sequence_info.csv; then  #Checks is the file already exists and creates it with a header if it doesn't
	echo "File does not exist yet"
	echo Strain,Contigs,Scaffolds,Length,GC_content,N50,L50,Telomeres,Telomere_matches,Busco_completeness,Percent_gaps >~/sequence_info.csv
fi

if ! grep "$seq_name" ~/sequence_info.csv -q; then   #Checks if a strain name is already present in csv,
#if so stops, otherwise appends sequence name and contig number and sends a message that a sequence has been added
	echo "$seq_name" "not in file, now added"

	#Retrieve some information from the busco summary text file
	busco_stats=$(~/scripts/busco_summary_extract.sh "$seq_name")

	total_length=$(echo "$busco_stats" | cut -d "," -f 4)
	no_scaffolds=$(echo "$busco_stats" | cut -d "," -f 2)
	no_contigs=$(echo "$busco_stats" | cut -d "," -f 3)
	busco_completeness=$(echo "$busco_stats" | cut -d "," -f 1)
	percent_gaps=$(echo "$busco_stats" | cut -d "," -f 5)

	echo "Total length is" "$total_length"

	#statement counts number of Cs and Gs (from echo to wc -m), then calculates GC_content
	#printf part makes sure the number is rounded to 2 decimals exactly
	GC_content=$(printf '%.2f\n' $(echo "scale=5 ;$(grep ">" $1 -v | tr -c -d ['GC'] | wc -m) / $total_length * 100" | bc))

	#Statements below call separate python scripts that calculate N50 and L50 respectively
	N50=$(python ~/scripts/N50_calculator.py "$1")
	L50=$(python ~/scripts/L50_calculator.py "$1")


	telomere_info=$(python ~/scripts/telomere_counter.py "$telo_file") #Calls separate script that counts telomeres
	#based on the _info.tsv output file from TeloVision. Scripts output is two numbers separated by a space.
	#first number is total number of telomeres found, second is telomere matches.
	num_of_telomeres=$(echo "$telomere_info" | cut -d " " -f 1)
	matched_telomeres=$(echo "$telomere_info" | cut -d " " -f 2)

	echo "$seq_name","$no_contigs","$no_scaffolds","$total_length","$GC_content""%","$N50","$L50","$num_of_telomeres","$matched_telomeres","$busco_completeness","$percent_gaps" >> ~/sequence_info.csv
fi
