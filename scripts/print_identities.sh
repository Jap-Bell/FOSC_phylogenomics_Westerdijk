#!/bin/bash
for file in ~/h/BLAST/PurOdoPhia_Blast/"$1"_res/"$2"*; 
do 
	echo "$file"; 
	grep "Identities" "$file" | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 -r
done
