#!/bin/bash

filepath=$1
filename=$(basename "$filepath" | cut -d "." -f 1)
#echo $filename | cut -d '-' -f 1
filename="~/TeloVisionOut/"$filename"_info.tsv"
echo $filename
#Alternative, which can be used in single command statements

#while read line; do echo $line | cut -d " " -f 1,5 ; done < TeloVisionOut/Fusarium_cugenangense_info.tsv
