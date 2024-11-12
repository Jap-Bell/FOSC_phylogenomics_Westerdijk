#!/usr/bin/env python

#Python script that takes the _info.tsv file from TeloVision and calculates the total amount of telomeres found,
#And also the number of matched telomeres (telomeres on the 3' and 5' ends of the same scaffold), thereby indicating
#A complete chromosome

import sys
from os.path import expanduser

def telomere_counter(TeloFile):
	with open(TeloFile) as infile:
		telomeres = []
		for line in infile:
			telomeres.append(line.split()[4])

		telomeres = telomeres[1:]
		num_of_telomeres = telomeres.count("Y")
		matched_telomeres = 0
		for index in range(0, len(telomeres)):
			if (index % 2 == 0):
				if telomeres[index] == "Y":
					if telomeres[index+1] == "Y":
						matched_telomeres += 1

		print(num_of_telomeres, matched_telomeres)


telomere_counter(TeloFile=expanduser(sys.argv[1]))
