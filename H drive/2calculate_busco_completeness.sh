#!/bin/bash

calc_busco_completeness () {
	Sequences_Anouk="$HOME/g/Group Crous/000INTERNS/Jasper/Sequences_Anouk"
	touch "$Sequences_Anouk"/busco_completeness.txt
	touch "$Sequences_Anouk"/low-busco_assemblies.txt
	
	for folder in "$Sequences_Anouk"/Busco_files/BUSCO/* 
	do 
		sequence=$(echo "$folder" | rev | cut -d"/" -f1 | rev)
		if [ "$(grep "$sequence" "$Sequences_Anouk"/busco_completeness.txt -c)" -eq 0 ]
		then
			cd "$folder" || exit
	       		n_busco_genes=$(find ./*.faa | wc -l)
	       		busco_completeness=$(("$n_busco_genes" * 100 / 4494))
			echo "$sequence has $n_busco_genes busco genes for $busco_completeness % completeness"
			echo "$sequence $busco_completeness $n_busco_genes" >> "$Sequences_Anouk"/busco_completeness.txt
		
			if [ "$busco_completeness" -lt 90 ]
			then
				echo "$sequence $busco_completeness $n_busco_genes" >> "$Sequences_Anouk"/low-busco_assemblies.txt
			fi
		fi
	done
}


calc_busco_completeness
