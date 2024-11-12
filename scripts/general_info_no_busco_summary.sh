#!/bin/bash

#Script that finds: the number of contigs, total sequence length, GC_content, N50, L50, number of telomeres and number of telomere matches (2 telomeres on opposite ends of a contig)
#outputs to ~/h/Metadata_sequences/Sequence_info.txt

#Required inputs: 1. FASTA-file 2. TeloVision *_info.tsv file
#Dependencies: ~/h/scripts/N50_calculator.py, ~/h/scripts/L50_calculator.py, ~/h/scripts/telomere_counter.py

seq_name=$(basename "$2" | cut -d "." -f1) #I have to use the second input $2 because the space in "Group Crous" splits my input location into 2 parts.
echo "$seq_name is being worked on"
#telo_file="~/h/TeloVisionOut/"$seq_name"_info.tsv"
cd $(dirname "$1")
Sequences_Anouk="$HOME/g/Group Crous/000INTERNS/Jasper/Sequences_Anouk"

if ! test -f ~/h/Metadata_sequences/Sequence_info.txt; then  #Checks is the file already exists and creates it with a header if it doesn't
	echo "File does not exist yet"
	echo "Strain Contigs Length GC_content N50 L50 Busco_completeness" >> ~/h/Metadata_sequences/Sequence_info.txt
fi

if ! grep "$seq_name" ~/h/Metadata_sequences/Sequence_info.txt -q; then   #Checks if a strain name is already present in csv,
#if so stops, otherwise appends sequence name and contig number and sends a message that a sequence has been added
	echo "$seq_name" "not in file, now added"

	total_length=$(grep -v ">" "$1 $2" | tr -d "\n" | wc -c)
	no_contigs=$(grep ">" "$1 $2" -c)
	busco_completeness=$(grep "$seq_name" "$Sequences_Anouk"/busco_completeness.txt | cut -d" " -f3)

	echo "Total length is" "$total_length"

	#statement counts number of Cs and Gs (from echo to wc -c), then calculates GC_content
	#printf part makes sure the number is rounded to 2 decimals exactly
	GC_content=$(printf '%.2f\n' $(echo "scale=5 ;$(grep ">" "$1 $2" -v | tr -c -d ['GC'] | wc -c) / "$total_length" * 100" | bc))

	#Statements below call separate python scripts that calculate N50 and L50 respectively
	N50=$(python ~/h/scripts/N50_calculator.py "$1 $2")
	L50=$(python ~/h/scripts/L50_calculator.py "$1 $2")


	#telomere_info=$(python ~/h/scripts/telomere_counter.py "$telo_file") #Calls separate script that counts telomeres
	#based on the _info.tsv output file from TeloVision. Scripts output is two numbers separated by a space.
	#first number is total number of telomeres found, second is telomere matches.
	#num_of_telomeres=$(echo "$telomere_info" | cut -d " " -f 1)
	#matched_telomeres=$(echo "$telomere_info" | cut -d " " -f 2)

	echo "$seq_name" "$no_contigs" "$total_length" "$GC_content""%" "$N50" "$L50" "$busco_completeness""%" #>> ~/h/Metadata_sequences/Sequence_info.txt #"$num_of_telomeres" "$matched_telomeres" 
fi
echo " "
