#!/bin/bash

##Problems to be solved:
# - Does not check if a sequence already has an entry into the final output files, so will keep appending if rerun.
# - If no BLAST hit was found, returns an uggly error -- not high priority but something to keep in mind

#Takes 2 inputs: $1 = the directory on which this script should be ran; $2 is the minimum percent identity for which the summary file should be created
#Script can be run multiple times each time with a lower threshold to get all strains with their maximum identity

# Gives 4 output files:
# - similarity_summary                  holds the similarity percantage of each gene for the sequences that map to either query species or even both
# - short_alignments                    holds per line a gene in a strain for which the alignment length was <90% of the query length
# - sequence_to_species_similarity      Holds per line a strain and to what query species it was most similar (three values: $species1, $species2 or "both") 
# - all_identities                      holds the length and percent identity of the best blast hit of each query gene in each species for each strain


#Set inputs to variables for easier reading in rest of code
input_directory=$(realpath "$1")
minimum_identity="$2"

#Set gene lengths as variables
# Ex-type genes are all of the same length, so only one variable per gene needs to be set
## Lengths have already been reduced to 90% of total gene length, as this will be the cutoff used for minimal alignment length
rpb2_length=775 #(861 original length)
rpb1_length=1300 #(1444 original length)
tef1_length=517 #(574 original length)

#Change to input folder for easier looping
cd "$input_directory" || exit

#Loop over files in indicated folder.
for folder in ./*_res
do
	strain_name_res=$(echo "$folder" | rev | cut -d "/" -f1 | rev) #Get name of the folder without path in front
	strain_name=${strain_name_res::-4}      #Get name of the strain, i.e. remove "_res" from the folder name
	echo "Working on: $strain_name" #Used to visualize the running of the script

	#Setting switches to determine what output to write to sequence_to_species_similarity.txt
	Sanga_status=0
	Kali_status=0

	#Code structure below is the same for each of the 6 genes
	##Grep all lines with the word "Identities", isolate the alignment length and percent identity. Then sort first on length, then on identity and finaly keep only top hit (highest identity for longest length)
	rpb2_Sanga_stats=$(grep "Identities" ./"$strain_name_res"/rpb2_Sanga."$strain_name".out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 --numeric -r | head -n1)
	strain_rpb2_Sanga_length=$(echo "$rpb2_Sanga_stats" | cut -d $'\t' -f1) #Isolate alignment length
	rpb2_Sanga_iden=$(echo "$rpb2_Sanga_stats" | cut -d $'\t' -f2) #Isolate percent identity
	
	rpb1_Sanga_stats=$(grep "Identities" ./"$strain_name_res"/rpb1_Sanga."$strain_name".out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 --numeric -r | head -n1)
	strain_rpb1_Sanga_length=$(echo "$rpb1_Sanga_stats" | cut -d $'\t' -f1) #Isolate alignment length
	rpb1_Sanga_iden=$(echo "$rpb1_Sanga_stats" | cut -d $'\t' -f2) #Isolate percent identity
															        
	tef1_Sanga_stats=$(grep "Identities" ./"$strain_name_res"/tef1_Sanga."$strain_name".out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort --numeric -k1,1 -r | head -n1)
	strain_tef1_Sanga_length=$(echo "$tef1_Sanga_stats" | cut -d $'\t' -f1) #Isolate alignment length
	tef1_Sanga_iden=$(echo "$tef1_Sanga_stats" | cut -d $'\t' -f2) #Isolate percent identity

	if [ "$strain_rpb2_Sanga_length" -ge "$rpb2_length" ] && [ "$rpb2_Sanga_iden" -ge "$minimum_identity" ]; then #Check if rpb2 alignement length is long enough and similarity is equal to or higher than thershold value
		if [ "$strain_rpb1_Sanga_length" -ge "$rpb1_length" ] && [ "$rpb1_Sanga_iden" -ge "$minimum_identity" ]; then #Check if rpb1 alignement length is long enough and similarity is equal to or higher than thershold value
			if [ "$strain_tef1_Sanga_length" -ge "$tef1_length" ] && [ "$tef1_Sanga_iden" -ge "$minimum_identity" ]; then
				Sanga_status=1
				echo "$strain_name is at least $minimum_identity% similar to all three Sangayamense genes"
				echo "$strain_name has $rpb2_Sanga_iden $rpb1_Sanga_iden $tef1_Sanga_iden percent identity to the Sangayamense genes (rpb2, rpb1, tef1)" >> ~/h/BLAST/SangaKali_Blast/similarity_summary.txt
			fi
		fi
	fi
																																													        
	if [ "$strain_tef1_Sanga_length" -lt "$tef1_length" ]; then
		echo "$strain_name tef1 Sanga alignment is too short!"
		echo "$strain_name tef1 Sanga alignment is too short! $strain_tef1_Sanga_length" >> ~/h/BLAST/SangaKali_Blast/short_alignments.txt
	fi

	if [ "$strain_rpb1_Sanga_length" -lt "$rpb1_length" ]; then
		echo "$strain_name rpb1 Sanga alignment is too short!"
		echo "$strain_name rpb1 Sanga alignment is too short! $strain_rpb1_Sanga_length" >> ~/h/BLAST/SangaKali_Blast/short_alignments.txt
	fi

	if [ "$strain_rpb2_Sanga_length" -lt "$rpb2_length" ]; then
		echo "$strain_name rpb2 Sanga alignment is too short!"
		echo "$strain_name rpb2 Sanga alignment is too short! $strain_rpb2_Sanga_length" >> ~/h/BLAST/SangaKali_Blast/short_alignments.txt
	fi

	#Code structure below is the same for each of the 6 genes
	##Grep all lines with the word "Identities", isolate the alignment length and percent identity. Then sort first on length, then on identity and finaly keep only top hit (highest identity for longest length)
	rpb2_Kali_stats=$(grep "Identities" ./"$strain_name_res"/rpb2_Kali."$strain_name".out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 --numeric -r | head -n1)
	strain_rpb2_Kali_length=$(echo "$rpb2_Kali_stats" | cut -d $'\t' -f1) #Isolate alignment length
	rpb2_Kali_iden=$(echo "$rpb2_Kali_stats" | cut -d $'\t' -f2) #Isolate percent identity
	
	rpb1_Kali_stats=$(grep "Identities" ./"$strain_name_res"/rpb1_Kali."$strain_name".out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 --numeric -r | head -n1)
	strain_rpb1_Kali_length=$(echo "$rpb1_Kali_stats" | cut -d $'\t' -f1) #Isolate alignment length
	rpb1_Kali_iden=$(echo "$rpb1_Kali_stats" | cut -d $'\t' -f2) #Isolate percent identity
	
	tef1_Kali_stats=$(grep "Identities" ./"$strain_name_res"/tef1_Kali."$strain_name".out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 -r --numeric | head -n1)
	strain_tef1_Kali_length=$(echo "$tef1_Kali_stats" | cut -d $'\t' -f1) #Isolate alignment length
	tef1_Kali_iden=$(echo "$tef1_Kali_stats" | cut -d $'\t' -f2) #Isolate percent identity

	if [ "$strain_rpb2_Kali_length" -ge "$rpb2_length" ] && [ "$rpb2_Kali_iden" -ge "$minimum_identity" ]; then #Check if alignement length is long enough and similarity is equal to or higher than thershold value
		if [ "$strain_rpb1_Kali_length" -ge "$rpb1_length" ] && [ "$rpb1_Kali_iden" -ge "$minimum_identity" ]; then #Check if alignement length is long enough and similarity is equal to or higher than thershold value
			if [ "$strain_tef1_Kali_length" -ge "$tef1_length" ] && [ "$tef1_Kali_iden" -ge "$minimum_identity" ]; then
				Kali_status=1
				echo "$strain_name is at least $minimum_identity% similar to all three Kalimantanense genes"
				echo "$strain_name has $rpb2_Kali_iden $rpb1_Kali_iden $tef1_Kali_iden percent identity to the Kalimantanense genes (rpb2, rpb1, tef1)" >> ~/h/BLAST/SangaKali_Blast/similarity_summary.txt
			fi
		fi
	fi
	
	if [ "$strain_tef1_Kali_length" -lt "$tef1_length" ]; then
		echo "$strain_name tef1 Kali alignment is too short!"
		echo "$strain_name tef1 Kali alignment is too short! $strain_tef1_Kali_length" >> ~/h/BLAST/SangaKali_Blast/short_alignments.txt
	fi

	if [ "$strain_rpb1_Kali_length" -lt "$rpb1_length" ]; then
		echo "$strain_name rpb1 Kali alginment is too short!"
		echo "$strain_name rpb1 Kali alignment is too short! $strain_rpb1_Kali_length" >> ~/h/BLAST/SangaKali_Blast/short_alignments.txt
	fi

	if [ "$strain_rpb2_Kali_length" -lt "$rpb2_length" ]; then
		echo "$strain_name rpb2 Kali alignment is too short!"
		echo "$strain_name rpb2 Kali alignment is too short! $strain_rpb2_Kali_length" >> ~/h/BLAST/SangaKali_Blast/short_alignments.txt
	fi

	echo "$strain_name has rpb2 $strain_rpb2_Sanga_length $rpb2_Sanga_iden rpb1 $strain_rpb1_Sanga_length $rpb1_Sanga_iden tef1 $strain_tef1_Sanga_length $tef1_Sanga_iden percent identity to the Sangayamense genes" >> ~/h/BLAST/SangaKali_Blast/all_identities.txt
	echo "$strain_name has rpb2 $strain_rpb2_Kali_length $rpb2_Kali_iden rpb1 $strain_rpb1_Kali_length $rpb1_Kali_iden tef1 $strain_tef1_Kali_length $tef1_Kali_iden percent identity to the Kalimantanense genes" >> ~/h/BLAST/SangaKali_Blast/all_identities.txt

	if [ "$Sanga_status" -eq 1 ] && [ "$Kali_status" -eq 1 ]; then
		echo "$strain_name      Both" >> ~/h/BLAST/SangaKali_Blast/sequence_to_species_similarity.txt
	elif [ "$Sanga_status" -eq 1 ]; then
		echo "$strain_name      Sangayamense" >> ~/h/BLAST/SangaKali_Blast/sequence_to_species_similarity.txt
	elif [ "$Kali_status" -eq 1 ]; then
		echo "$strain_name      Kalimantanense" >> ~/h/BLAST/SangaKali_Blast/sequence_to_species_similarity.txt
	fi
	
	echo " "

done
