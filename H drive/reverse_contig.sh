#!/bin/bash

#Practice first with Purpur contig 2
## Inputs in order: Genome_assembly, Bed_file, Contig(s) to be reversed

function rev_contig {
	genome_assembly="$1"
	bed_file="$2"
	contig="$3"

	#Copying bedfile to use as output reverse contig file
	bed_file_rev=$""$(echo "$bed_file" | rev | cut -d"." -f2- | rev )_rev.bed""
	test -e "$bed_file_rev" || cp "$bed_file" "$bed_file_rev"

	#Calculating contig length that can span across multiple lines
	contig_start=$(( $(grep ">$contig$" -n "$genome_assembly" | cut -d : -f 1 ) +1 ))
	contig_end=$(( $(tail -n +"$contig_start" "$genome_assembly" | grep -n ">" | head -n1 | cut -d : -f 1 ) - 1 + "$contig_start" - 1 )) #Cat assembly starting from contig of interest header, grep line number of next header and substract 1 to find last linenumber of contig of interest's sequence
	contig_length=$(sed -n "$contig_start,$contig_end""p" "$genome_assembly" | wc -c)

	awk -v contig_length="$contig_length" -v contig="$contig" '
	BEGIN{FS=OFS="\t"} 
	{for (i=1; i<NF; i++) if ($i == contig )  {
	end = (contig_length - $2)
	start = (contig_length - $3)
	$2 = start
	$3 = end }
  	}1' "$bed_file_rev" > tmp_file.txt

	mv tmp_file.txt "$bed_file_rev"

	echo "$contig has now been reversed! Reversed contig written to $bed_file_rev"

}


rev_contig "$1" "$2" "$3"
