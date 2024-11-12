#!/bin/bash

#Commands are in order and should be ran from top to bottom to respect dependecies on output files that are used as input files by subsequent commands
#Genome assemblies are stored in ~/Sequences/fusarium_assemblies_Germany

#Running TeloVision
##INPUTS: genome assemblies
##OUTPUTS: for each assembly creates to files in ~/TeloVisionOut/ with the strain name as file names
### Read TeloVision documentation for further details on output files
conda activate telovision
for file in ~/Sequences/fusarium_assemblies_Germany/*.fasta;
do
	output_name=$(echo $file | cut -d "/" -f 3 | cut -d "." -f 1)
	telovision -i $file -o ~/TeloVisionOut/$output_name
done
conda deactivate

#Running ArboPhyl
##INPUTS: genomes assemblies
##OUTPUTS: Many files, most important of which are in
###ArboPhyl runs MAFFT, Trimall and BUSCO in one go
###Make sure the ArboPhyl functional scripts are present in ~/Sequences/fusarium_assemblies_Germany
###If genome assembly files have the samen structure as mine, also place ArboPhylnameParser in this directory
python Arbophyl.py
# run with options:
# - analysis type = 0
# - reference dataset = hypocreales
# - number of cores = #Free


#Gathering general statistics
##INPUTS: genome assemblies, also implicitly TeloVision .tsv output file and busco summary file
##OUTPUTS: ~/sequence_info.csv
for file in ~/Sequences/fusarium_assemblies_Germany/*.fasta ; do ~/scripts/general_info.sh $file; done

###########################################################################
# Copy BUSCO outputs to a new folder, which only contains ingroup strains #
#         New folder should be named True_Fusarium_Sequences              #
###########################################################################

#Selecting those genes that are: shared by all species in the analysis, parsimony informative in the ingroup and parsimony informative in the outgroup
##INPUTS: ingroup-only and outgroup-included top folders
##OUTPUTS: most importantly : $outgroup_informative_genes --> holds the genes that fulfill above requirements
### NOTE that this removes all gene alignments that do not meet the criterea above from ~/Sequences/Oxysporum
### NOTE the folders in this command have to end on "/", otherwise parsing in the script breaks
cd ~/Sequences
~/scripts/compare_genesets.sh True_Fusarium_Sequences/ Oxysporum_two_outgroup/

#Run ArboPhyl on verified genes to make new tree with IQtree
cd Oxysporum_two_outgroup/
rm Partition.ne*
python Arbophyl.py
# analysis type = 7,8
# dataset = hypocreales
# ncores = #Free

#Adding gCA and sCA values to tree
#INPUTS: Species tree, folder with gene trees and partition file
#OUTPUTS: New version of Species tree with bootstrap, gCA and sCA support values
##Tree can be visualised using ITOL among others
#Making a single file that contains all gene trees
iqtree -s FilterBUSCOs_output/MAFFT_output/Trimmed_MSAs/Passed_MSA/ -S Partition.nex --prefix loci -T AUTO

#Running sCA and gCA simultaniously
iqtree2 -t Partition.nex.contree --gcf loci.treefile --prefix Boot_gCF_sCF_Tree --scf 100 -seed 977193 -p Partition.nex -T 1

#Making bootstrapped gene trees that can be used for comparison the species tree
cd ~/Sequences/Oxysporum_two_outgroup
for file in FilterBUSCOs_output/MAFFT_output/Trimmed_MSAs/Passed_MSA/Models/*/*_trimmed.fna.log
do
	model=$(grep "Best-fit model:" $file | cut -d " " -f3)
	alignment_file=$(echo ${file:0:-4})
	output_file=$((echo ${file:0:-16}) | sed 's/$/_bootstrapped/')
	iqtree -s "$alignment_file" -m "$model" -nt AUTO --prefix "$output_file" -bb 1000
done

#Making folder that holds all bootstrapped gene tree files
mkdir ./genetrees_bootstrapped
cp FilterBUSCOs_output/MAFFT_output/Trimmed_MSAs/Passed_MSA/Models/*/*_bootstrapped.contree

#Comparing the gene trees to the species tree
~/scripts/compare_trees.py ~/Sequences/Oxysporum_two_outgroup/Partition.nex.treefile ~/Sequences/Oxysporum_two_outgroup/genetrees_bootstrapped/
