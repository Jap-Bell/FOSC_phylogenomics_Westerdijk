#!/usr/bin/env python

#This script calculates robinson_foulds distance between a species tree and a host of gene trees
#Input 1: Species tree file (newick format)
#Input 2: folder with gene trees
#Input 3: outgroup species (should be present in all trees)

import sys
import subprocess
import re
import os
import pandas as pd

#Set conda environment to ete3 and import the software
cmd = '. /home/jbell/h/miniconda3/etc/profile.d/conda.sh && conda activate ete3'
#subprocess.call(cmd, shell=True, executable='/bin/bash') --> for some reason this doesn't work anymore, so I need to make sure ete3 is activated by hand before I can run.
from ete3 import Tree

#Setting the outgroup species (default is "Fusarium_lumajangense_ex_type-barcode10")
outgroup_species = sys.argv[3] or "Fusarium_lumajangense_ex_type-barcode10"

#Loading multigene tree
## This way I only have to read the file once, saving computation time
file = open(sys.argv[1], "r")
big_tree = file.read()
big_tree = Tree(big_tree, format=0) #Transforming into actual ete3 tree object
big_tree.set_outgroup(big_tree.get_leaves_by_name("Fusarium_lumajangense_ex_type-barcode10")[0]) #Rooting the tree
file.close()

def make_tree(tree_file):
	#defining gene tree
	file = open(tree_file, "r")
	genetree = file.read()
	genetree = Tree(genetree) #Transforming into ete3 tree object
	genetree.set_outgroup(genetree.get_leaves_by_name(outgroup_species)[0]) #Rooting tree	
	file.close()
	return genetree

#To store and output all distances I will make a list filled with dictionaries, where each dictionary holds one input row. This list I wil transform into a dataframe which I can write out to a text file.
rows_list = []
for gene_tree_file_short in os.listdir(os.path.abspath(sys.argv[2])):
        gene_tree_file = sys.argv[2]+"/"+gene_tree_file_short
        genetree = make_tree(tree_file=gene_tree_file)
        distance = big_tree.robinson_foulds(genetree)[0]
        
        gene=gene_tree_file_short.split("_")[0] #extracting only gene name for outputting

        dict1 = {'Gene': gene, 'RF_Distance': distance}
        rows_list.append(dict1)
        
        if distance < 100:
            print(gene_tree_file_short)

df=pd.DataFrame(rows_list, columns=['Gene', 'RF_Distance'])

output_file=sys.argv[2][2:]+"_distances.txt" #Setting the output name such that the dataframe is outputted outside of the Clade folder (all distance matrixes will go to Genetrees)

df.to_csv(output_file, sep='\t', index=False, header=False)
