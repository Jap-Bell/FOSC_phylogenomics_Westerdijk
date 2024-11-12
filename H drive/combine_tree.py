#!/usr/bin/env python

import sys
from ete3 import Tree

def combine_trees(tree_with_pp, tree_with_bl, output_tree):
    # Load the trees
    t1 = Tree(tree_with_pp)
    #print(t1)
    t2 = Tree(tree_with_bl)
    print(t2)

    # Check if topologies match
    #for n1, n2 in zip(t1.traverse(), t2.traverse()):
    #    if n1.name != n2.name:
    #        raise ValueError("Trees have different topologies")

    # Combine the trees
    for n1, n2 in zip(t1.traverse(), t2.traverse()):
        n2.support = n1.support

    # Save the combined tree
    t2.write(outfile=output_tree)

if __name__ == "__main__":
    tree_with_pp = sys.argv[1]
    tree_with_bl = sys.argv[2]
    output_tree = sys.argv[3]
    combine_trees(tree_with_pp, tree_with_bl, output_tree)
