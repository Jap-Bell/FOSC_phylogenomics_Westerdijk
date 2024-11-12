#!/bin/bash

calc_busco_completeness () {
	Sequences_Anouk="$HOME/g/Group Crous/000INTERNS/Jasper/Sequences_Anouk"
	touch "$Sequences_Anouk"/busco_completeness.txt
	touch "$Sequences_Anouk"/low-busco_assemblies.txt
	
	for folder in "$Sequences_Anouk"/Busco_files/BUSCO/* 
	do 
		cd "$folder" || exit
	       	n_busco_genes=$(ls -l *.faa | wc -l)
	       	sequence=$(echo "$folder" | rev | cut -d"/" -f1 | rev)
	       	busco_completeness=$(("$n_busco_genes" * 100 / 4494))
	
		if [ "$(grep "$sequence" "$Sequences_Anouk"/busco_completeness.txt -c)" -eq 0 ]
		then
			echo "$sequence has $n_busco_genes busco genes for $busco_completeness % completeness"
			echo "$sequence $busco_completeness $n_busco_genes" >> "$Sequences_Anouk"/busco_completeness.txt
		fi

		if [ "$busco_completeness" -lt 90 ]
		then
			echo "$sequence $busco_completeness $n_busco_genes" >> "$Sequences_Anouk"/low-busco_assemblies.txt
		fi
	done
}


calc_busco_completeness
