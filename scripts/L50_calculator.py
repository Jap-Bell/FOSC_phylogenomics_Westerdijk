#!/usr/bin/env python
import sys

def L50_calculator(input_file):
    contig_lengths = []
    gene_starts = []
    with open(input_file) as fasta_file:
        lines = fasta_file.readlines()
        for line_number, line in enumerate(lines):
            if line[0] == ">":
                contig_length=0
                next_line = line_number + 1
                while lines[next_line][0] != ">" and next_line in range(len(lines)-1):
                    contig_length += len(lines[next_line]) - 1 #len() also counts newlines, so I just substract that character every time. Probably more efficient than stripping them (and easier to code for sure)
                    next_line += 1
                    
                contig_lengths.append(contig_length)
        
        contig_lengths[-1] += len(lines[-1]) - 1 #Counting the basepairs of the last contig as they are exluded in the loop above 
        
    contig_lengths.sort(reverse=False)
    total_length = sum(contig_lengths)

    count_length = 0
    L50_index =0
        
    while count_length < total_length/2:
        count_length += contig_lengths[L50_index]
        L50_index +=1

    L50_length=contig_lengths[L50_index]
    print(L50_length)

L50_calculator(input_file=sys.argv[1])
