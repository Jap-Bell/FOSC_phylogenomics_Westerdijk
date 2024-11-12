#!/usr/bin/env python

import sys
import subprocess
import re
import os

#Set conda environment to ete3 and import the software
cmd = '. /home/jbell/miniconda3/etc/profile.d/conda.sh && conda activate ete3'
subprocess.call(cmd, shell=True, executable='/bin/bash')
from ete3 import Tree


#Loading multigene tree
## This way I only have to read the file once, saving computation time
file = open(sys.argv[1], "r")
big_tree = file.read()
big_tree = re.sub( "([0-9]{1,3})/[0-9]{1,3}", "\\1", big_tree) #Removing bootstrap values from tree, as etetools cant deal with them
big_tree = Tree(big_tree, format=0) #Transforming into actual tree object
big_tree.set_outgroup(big_tree.get_leaves_by_name("Fusarium_lumajangense_ex_type-barcode10")[0]) #Rooting the tree
file.close()

print("Main species tree used for comparison:")
print(big_tree)

def make_tree(tree_file):
	#defining the gene tree
	file = open(tree_file, "r")
	genetree = file.read()
	genetree = re.sub( "([0-9]{1,3})/[0-9]{1,3}", "\\1", genetree) #Removing bootstrap values as etetools cant d>        genetree.set_outgroup(genetree.get_leaves_by_name("Fusarium_lumajangense_ex_type-barcode10")[0]) #Rooting th>        file.close()
	genetree = Tree(genetree)
	genetree.set_outgroup(genetree.get_leaves_by_name("Fusarium_lumajangense_ex_type-barcode10")[0]) #Rooting th>	
	file.close()
	return genetree

for gene_tree_file_short in os.listdir(os.path.abspath(sys.argv[2])):
	gene_tree_file = sys.argv[2]+gene_tree_file_short
	genetree = make_tree(tree_file=gene_tree_file)
	distance = big_tree.robinson_foulds(genetree)[0]
	if distance == 0:
		print(gene_tree_file_short)
