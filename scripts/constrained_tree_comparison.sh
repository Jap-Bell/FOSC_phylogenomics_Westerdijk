#!/bin/bash

function run_genetree {
	echo "Computing free topology"
	iqtree2 -s "$2_trimmed.fna" -m "MF" --prefix "$path""$2_genetree" -nt AUTO -o Fusarium_lumajangense_ex_type-barcode10 -quiet
}


function run_constrained_tree {
	#Read substitution model
	sub_model=$(grep "Model of substitution:" "$1" | cut -d" " -f4)
	echo "Computing constrained topology"
	#Re-run IQtree with constrained topology
	iqtree2 -s "$path""$2_trimmed.fna" -m "$sub_model" --prefix "$path""$2_constrained" -g ~/h/Genetrees/constrained_topology.nwk -nt AUTO -o Fusarium_lumajangense_ex_type-barcode10 -keep-ident -quiet
}

function compare_likelihoods {
	#Get log-likelihood numbers from free tree
	free_LL=$(grep "Log-likelihood of the tree:" "$1" | cut -d" " -f5)
	free_LL_SE=$(grep "Log-likelihood of the tree:" "$1" | cut -d" " -f7 | cut -d")" -f1)
	#Define LL range of free tree
	free_LL_min=$(echo "$free_LL - $free_LL_SE" | bc -l)
	free_LL_max=$(echo "$free_LL + $free_LL_SE" | bc -l)

	#Get log-likelihood numbers from constrained tree
        con_LL=$(grep "Log-likelihood of the tree:" "$2" | cut -d" " -f5)
        con_LL_SE=$(grep "Log-likelihood of the tree:" "$2" | cut -d" " -f7 | cut -d")" -f1)
	#Define LL range of constrained tree
	con_LL_min=$(echo "$con_LL - $con_LL_SE" | bc -l)
	con_LL_max=$(echo "$con_LL + $con_LL_SE" | bc -l)

	#Search for overlap in LL ranges
	if (( $(echo "$con_LL_min < $free_LL_max" | bc -l) && $(echo "$con_LL_min > $free_LL_min" | bc -l) )) || (( $(echo "$con_LL_max < $free_LL_max" | bc -l) && $(echo "$con_LL_max > $free_LL_min" | bc -l) )); then
		echo "Log-likelihood of $3 does not differ between free and constrained tree (Free: $free_LL +- $free_LL_SE | Con: $con_LL +- $con_LL_SE) " >> LL_differences.txt
	else
		echo "Log-likelihoods of trees are signidicantly differen: LL of $3 free tree: $free_LL +- $free_LL_SE | LL of $3 constrained tree: $con_LL +- $con_LL_SE" >> LL_differences.txt
	fi
}

cd "$1" || exit #change to whatever is put as input
for docfile in ./FilterBUSCOs_output/MAFFT_output/Trimmed_MSAs/Passed_MSA/Models/*/*_trimmed.fna.iqtree
do
	echo "Working on $docfile"
	gene=$(basename -- "$docfile" .iqtree | cut -d"_" -f1)
	path="./FilterBUSCOs_output/MAFFT_output/Trimmed_MSAs/Passed_MSA/Models/$gene/"

	test -e "$path""$gene"_genetree.iqtree || run_genetree "$docfile" "$gene"

	test -e "$path""$gene"_constrained.iqtree || run_constrained_tree "$docfile" "$gene"

	compare_likelihoods "$path""$gene"_genetree.iqtree "$path""$gene"_constrained.iqtree "$gene"
	echo " "
done
