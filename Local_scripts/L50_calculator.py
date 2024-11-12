#!/usr/bin/env python
import sys

def N50_calculator(input_file):
	contig_lengths = []
	with open(input_file) as fasta_file:
		for line in fasta_file:
			if line[0] != ">":
				contig_lengths.append(len(line))

	contig_lengths.sort(reverse=False)
	total_length = sum(contig_lengths)

	count_length = 0
	L50_index =0

	while count_length < total_length/2:
		count_length += contig_lengths[L50_index]
		L50_index +=1

	L50_length=contig_lengths[L50_index]
	print(L50_length)

N50_calculator(input_file=sys.argv[1])
