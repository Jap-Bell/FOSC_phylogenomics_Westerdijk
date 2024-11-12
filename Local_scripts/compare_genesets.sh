#!/bin/bash

# INPUTS: $1 = the ingroup folder, $2 = the outgroup folder

#set -xv

function compare_genesets {

	ingroup=$1
	outgroup=$2

	#Set PATH variable
	## local makes sure the variable is only accessible in the function
	local file_path="FilterBUSCOs_output/MAFFT_output/Trimmed_MSAs/Passed_MSA/Models"

# 1. Make lists of all aligned genes in both directories
	echo "Step 1.1: Making a list of all aligned genes in the ingroup (output file: $ingroup Aligned_genes.txt)"

	touch "$ingroup"Aligned_genes.txt
	touch "$outgroup"Aligned_genes.txt

	for file in "$ingroup""$file_path"/*/*_trimmed.fna
		do
		gene=$(echo "$file" | rev | cut -d "/" -f 2 | rev)
		if (( $(grep "\b$gene\b" "$ingroup"Aligned_genes.txt -c) == 0)); then
			echo "$gene" >> "$ingroup"Aligned_genes.txt
		fi
		done

	echo "Step 1.2: Making a list of all aligned genes in the outgroup (output file: $outgroup Aligned_genes.txt)"

	for file in "$outgroup""$file_path"/*/*_trimmed.fna
		do
		gene=$(echo "$file" | rev | cut -d "/" -f 2 | rev)
		if (( $(grep "\b$gene\b" "$outgroup"Aligned_genes.txt -c ) == 0)); then
			echo "$gene" >> "$outgroup"Aligned_genes.txt
		fi
		done

# 2. Remove genes in outgroup not included in ingroup analysis and generate file that holds these gene names
	## A list of genes that are unique to the outgroup is storedin outgroup/not_in_ingroup.txt, these genes are subsequently removed from the outgroup folder
	echo "Step 2: Removing genes from the outgroup folder that were not included in the ingroup folder (output file: $outgroup not_in_ingroup.txt)"

	comm -23 "$outgroup"Aligned_genes.txt "$ingroup"Aligned_genes.txt > "$outgroup"not_in_ingroup.txt
	while IFS= read -r line
		do
		rm -r "$outgroup""$file_path"/"\b$line\b"
		done < "$outgroup"not_in_ingroup.txt

# 3. Determine the number of parsimony informative sites in the ingroup
	## Output is used as an input for step 4, but is only from the ingroup. Hence, the same script can be performed on the outgroup later.
	## In this way, some computational time is saved and no unused genes are listed in check_parsimony_sites.txt output for the outgroup

	echo "Step 3: Determining the number of informative positions per gene in the ingroup (output files: $ingroup parsimonious_genes.txt and $ingroup non_parsimonious_genes.txt)"

	for file in "$ingroup""$file_path"/*/*_trimmed.fna.iqtree
		do
		~/scripts/check_parsimony_sites.sh "$file" "$ingroup"
		done

# 4. Remove genes that had no informative positions in the ingroup
	## Stores a list of the non-informative genes in outgroup/not_ingroup_informative and removes any gene models from these genes from the outgroup folder

	echo "Step 4: Removing genes from the outgroup that had no informative positions in the ingroup (output file: $outgroup not_ingroup_informative)"

	comm -12 "$outgroup"Aligned_genes.txt "$ingroup"non_parsimonious_genes.txt >> "$outgroup"not_ingroup_informative.txt

	while IFS= read -r line
		do
		rm -r "$outgroup""$file_path"/"\b$line\b"
		done < "$outgroup"not_ingroup_informative.txt

# 5. Determine the number of parsimony informative sites in the outgroup
	## Output is used for step 6

	echo "Step 5: Determining the number of informative sites per gene in the outgroup (output files: $outgroup parsimonious_genes and $outgroup non_parsimonious_genes.txt)"

	for file in "$outgroup""$file_path"/*/*_trimmed.fna.iqtree
		do
		~/scripts/check_parsimony_sites.sh "$file" "$outgroup"
		done
# 6. Remove genes with no informative positions in outgroup geneset
##Should include a check if the file exists here before I try to remove it, saves me some unwanted screen output if I do a re-run
	echo "Step 6: Removing genes with no informative positions in the outgroup"

	while IFS= read -r line
		do
		rm -r "$outgroup""$file_path"/"\b$line\b"
		done < "$outgroup"non_parsimonious_genes.txt
# 7. See what genes of the ingroup are not used in the outgroup tree

	echo "Step 7: Finding genes that are not used in the ougroup that were used in the ingroup (output files: $outgroupoutgroup_used_genes.txt $outgroup lost_informative_genes.txt $ingroup informative_genes_names.txt)"

	#Creating output files such that I can grep in and write to them
	touch "$outgroup"outgroup_used_genes.txt
	touch "$ingroup"informative_genes_names.txt
	touch "$outgroup"lost_informative_genes.txt

	echo "Step 7.1: Create file that holds only the names of the parsimony informative genes in the outgroup"
	#Create a file that holds the names of the parsimony informative genes in the outgroup
	for file in "$outgroup""$file_path"/*/*_trimmed.fna
		do
		gene=$(echo "$file" | rev | cut -d "/" -f 2 | rev)
		if (( $(grep "\b$gene\b" "$outgroup"outgroup_used_genes.txt -c) == 0 )); then
			echo "$gene" >> "$outgroup"outgroup_used_genes.txt
		fi
		done
	echo "Step 7.2: Create file that holds only the names of the parsimony informative genes in the ingroup"
	#Create a file that has only the names of the informative genes in the ingroup
	while IFS= read -r line
		do
		gene=$(echo "$line" | cut -d "," -f1)
		if (( $(grep "\b$gene\b" "$ingroup"informative_genes_names.txt -c) ==0 )); then
			echo "$gene" >> "$ingroup"informative_genes_names.txt
		fi
		done < "$ingroup"parsimonious_genes.txt


	echo "Step 7.3: Compare ingroup informative genes with remaining outgroup informative genes"
	#compare the list of ingroup informative genes to the genes that remain after removing genes from the outgroup
	comm -23 "$ingroup"informative_genes_names.txt "$outgroup"outgroup_used_genes.txt >> "$outgroup"lost_informative_genes.txt

#Printing some output messages
	echo ""
	echo "_____________________________________________________________________________________________________________________"
	echo "Comparison finished!"
	echo "Output files created are:"
	echo "IN- AND OUTGROUP FOLDERS: Aligned_genes.txt, parsimonous_genes.txt, non_parsimonous_genes.txt"
	echo "INGROUP FOLDER ONLY: informative_genes_names.txt"
	echo "OUTGROUP FOLDER ONLY: not_in_ingroup.txt, not_ingroup_informative, outgroup_used_genes.txt, lost_informative_genes.txt"
	echo "Non informative and outgroup unique genes have been removed from the outgroup folder!"
	echo "_____________________________________________________________________________________________________________________"
}

compare_genesets "$1" "$2"
