#!/bin/bash
##Updated such that all paths are relative now
##Also changed output file name from ..._parsimonous to .._parsimonious as apperently that is the correct spelling

#set -xv

function check_parsimony_sites {
        parsimony_sites=$(grep "parsimony" "$1" | cut -d ":" -f2)
	gene=$(echo "$1" | rev | cut -d "/" -f2 | rev)

	if (("$parsimony_sites" == 0)); then
                echo "$gene" "has no parsimony informative sites!"

		#If there are no informative sites, add the gene to a list of non-parsimonous genes
		if (( $(grep "\b$gene\b" "$2"non_parsimonious_genes.txt -c) == 0 )); then
			echo "$gene" >> "$2"non_parsimonious_genes.txt
		fi
	fi

	if (("$parsimony_sites" > 0)); then
#		echo "$gene" "has" "$parsimony_sites" "informative sites"
		#Add the gene and the number of informative sites to a file such that I can easily acces this info
		if (( $(grep "\b$gene\b" "$2"parsimonious_genes.txt -c) == 0 )); then
                	echo "$gene"",""$parsimony_sites" >> "$2"parsimonious_genes.txt
		fi
        fi
}

touch "$2"non_parsimonious_genes.txt
touch "$2"parsimonious_genes.txt

check_parsimony_sites "$1" "$2"

