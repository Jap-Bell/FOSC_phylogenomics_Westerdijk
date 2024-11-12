#!/bin/bash

seq_name=$1
busco_summary_file="h/Sequences/BUSCO_output_all_strains/"$seq_name"/short_summary.specific.hypocreales_odb10."$seq_name".txt"

busco_completeness=$(grep "C:" $busco_summary_file | cut -d "%" -f1 | cut -d ":" -f2 | xargs)
no_scaffold=$(grep "Number of scaffolds" $busco_summary_file | cut -d "N" -f1 | xargs)
no_contigs=$(grep "Number of contigs" $busco_summary_file | cut -d "N" -f1 | xargs)
total_length=$(grep "Total length" $busco_summary_file | cut -d "T" -f1 | xargs)
percent_gaps=$(printf '%.2f\n' $(grep "Percent gaps" $busco_summary_file | cut -d "%" -f1 | xargs))

echo $busco_completeness"%", $no_scaffold, $no_contigs, $total_length, $percent_gaps"%"




#$(printf '%.2f\n' $(echo "scale=5 ;$(grep ">" $1 -v | tr -c -d ['GC'] | wc -m) / $total_length * 100" | bc))
