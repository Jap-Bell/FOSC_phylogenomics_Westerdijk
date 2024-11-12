#!/bin/bash
#Changed the input such that it takes a local lineage file that is pre-downloaded
#Changed the output file name parsing to fit my set-up
if [[ "$1" == "busco" ]]; then
    conda activate busco
    for file in *fasta
    do
	output_name=$(./ArboPhyl_name_parser.sh $file)
        test -e $output_name && echo "$output_name has already had BUSCO analysis performed" || busco -i $file -o $(./ArboPhyl_name_parser.sh $file) -l hypocreales_odb10 --offline --download_path ~/h/busco_downloads -m genome -c 5
#        busco -i $file -o ${file/_*/""}/ -l $2 -m genome -c $3
    done
fi

if [[ "$1" == "mafft" ]]; then
    cd FilterBUSCOs_output/
    conda activate mafft
    mkdir MAFFT_output
    for file in *fna
    do
	test -e "MAFFT_output/${file/MS/"MSA"}" && echo "$file has been aligned already!" || mafft --auto --inputorder --thread $2 "$file" > "MAFFT_output/${file/MS/"MSA"}"
    done
fi

if [[ "$1" == "trimal" ]]; then
    cd FilterBUSCOs_output/MAFFT_output/
    conda activate trimal
    mkdir Trimmed_MSAs
    for file in *fna
    do
        trimal -in $file -out Trimmed_MSAs/${file/MSA/"trimmed"} -strict
    done
fi

if [[ "$1" == "iqtree_models" ]]; then
    cd FilterBUSCOs_output/MAFFT_output/Trimmed_MSAs/Passed_MSA
    mkdir Models
    for file in *fna
    do
        mkdir Models/${file/_trimmed.fna/""}
        cp $file Models/${file/_trimmed.fna/""}
    done

    cd Models/
    conda activate iqtree
    for dir in *
    do
    cd $dir
    iqtree -s *.fna -m MF -nt $2
    cd ..
    done
fi

if [[ "$1" == "iqtree" ]]; then
    conda activate iqtree
    iqtree -s FilterBUSCOs_output/MAFFT_output/Trimmed_MSAs/Passed_MSA/ -p Partition.nex -bb 1000 -alrt 1000 -nt $2 
fi