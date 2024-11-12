#!/bin/bash

##Problems to be solved:
# - Does not check if a sequence already has an entry into the final output files, so will keep appending if rerun.

#Takes 2 inputs: $1 = the directory on which this script should be ran; $2 is the minimum percent identity for which the summary file should be created

# Gives 3 output files:
# - similarity_summary                  holds the similarity percantage of each gene for the sequences that map to either phialophorum or odoratissimum or even both
# - short_alignments                    holds per line a gene in a strain for which the alignment length was <90% of the query length
# - sequence_to_species_similarity      Holds per line a strain and to what query species it was most similar (phia, odo or both)

#Set inputs to variables for easier reading in rest of code
input_directory=$(realpath "$1")
minimum_identity="$2"

#Set gene lengths as variables
## Lengths have already been reduced to 90% of total gene length, as this will be the cutoff used for minimal alignment length
rpb2_length=775 #(861 original length)
rpb1_length=1300 #(1444 original length)
tef1_length=515 #(572 original length)

#Change to input folder for easier looping
cd "$input_directory" || exit

#Determine how many species have been BLASTed and what their short-names are. Get those in a list
cd "$(ls -d ./*_res | head -n 1)" || exit #Move into the first directory listed in ls
n_species=$(ls rpb1* | wc -l) #Find the number of species for which BLAST has been performed in this folder
species_names=$(ls rpb1* | cut -d"_" -f2 | cut -d"." -f1 | tr '\n' ' ') #Make a makeshift list of the species for which BLAST has been performed in this folder
cd "$input_directory" || exit 

for folder in ./*_res
do
	strain_name_res=$(echo "$folder" | rev | cut -d "/" -f1 | rev) #Get name of the folder without path in front
	strain_name=${strain_name_res::-4}      #Get name of the strain, i.e. remove "_res" from the folder name
	echo "Working on: $strain_name" #Used to visualize the running of the script
	
	for n in $(seq 1 "$n_species") #Performs the whole loop as many times as there are species BLASTed for in the folder
	do
		query_species=$(echo "$species_names" | cut -d" " -f "$n") #Pick the n'th species in the list, such that for each loop another species is evaluated

		rpb2_stats=$(grep "Identities" ./"$strain_name_res"/rpb2_"$query_species"."$strain_name".out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 --numeric -r | head -n1)
	        strain_rpb2_length=$(echo "$rpb2_stats" | cut -d $'\t' -f1) #Isolate alignment length
	        rpb2_iden=$(echo "$rpb2_stats" | cut -d $'\t' -f2) #Isolate percent identity

	        rpb1_stats=$(grep "Identities" ./"$strain_name_res"/rpb1_"$query_species"."$strain_name".out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 --numeric -r | head -n1)
		strain_rpb1_length=$(echo "$rpb1_stats" | cut -d $'\t' -f1) #Isolate alignment length
		rpb1_iden=$(echo "$rpb1_stats" | cut -d $'\t' -f2) #Isolate percent identity

		tef1_stats=$(grep "Identities" ./"$strain_name_res"/tef1_"$query_species"."$strain_name".out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort --numeric -k1,1 -r | head -n1)
		strain_tef1_length=$(echo "$tef1_stats" | cut -d $'\t' -f1) #Isolate alignment length
		tef1_iden=$(echo "$tef1_stats" | cut -d $'\t' -f2) #Isolate percent identity

		if [ "$strain_rpb2_length" -ge "$rpb2_length" ] && [ "$rpb2_iden" -ge "$minimum_identity" ]; then #Check if alignement length is long enough and similarity is equal to or higher than thershold value
			if [ "$strain_rpb1_length" -ge "$rpb1_length" ] && [ "$rpb1_iden" -ge "$minimum_identity" ]; then #Check if alignement length is long enough and similarity is equal to or higher than thershold value
				if [ "$strain_tef1_length" -ge "$tef1_length" ] && [ "$tef1_iden" -ge "$minimum_identity" ]; then
					echo "$strain_name is at least $minimum_identity% similar to all three $query_species genes"
					echo "$strain_name has $rpb2_iden $rpb1_iden $tef1_iden percent identity to the $query_species genes (rpb2, rpb1, tef1)" >> "$input_directory"/similarity_summary.txt
				fi
			fi
		fi
	
		if [ "$strain_tef1_length" -lt "$tef1_length" ]; then
	        	echo "$strain_name tef1 $query_species alignment is too short!"
			echo "$strain_name tef1 $query_species alignment is too short! $strain_tef1_length" >> "$input_directory"/short_alignments.txt
		fi

		if [ "$strain_rpb1_length" -lt "$rpb1_length" ]; then
			echo "$strain_name rpb1 $query_species alignment is too short!"
			echo "$strain_name rpb1 $query_species alignment is too short! $strain_rpb1_length" >> "$input_directory"/short_alignments.txt
		fi

		if [ "$strain_rpb2_length" -lt "$rpb2_length" ]; then
			echo "$strain_name rpb2 $query_species alignment is too short!"
			echo "$strain_name rpb2 $query_species alignment is too short! $strain_rpb2_length" >> "$input_directory"/short_alignments.txt
		fi
	
		echo "$strain_name has rpb2 $strain_rpb2_length $rpb2_iden rpb1 $strain_rpb1_length $rpb1_iden tef1 $strain_tef1_length $tef1_iden percent identity to the $query_species genes" >> "$input_directory"/all_identities.txt

	done
done


#############################################################################################################################################################################################################################################

#Loop over files in indicated folder.
#for folder in ./*_res
#do
#	strain_name_res=$(echo "$folder" | rev | cut -d "/" -f1 | rev) #Get name of the folder without path in front
#	strain_name=${strain_name_res::-4}      #Get name of the strain, i.e. remove "_res" from the folder name
#	echo "Working on: $strain_name" #Used to visualize the running of the script
#
	#Setting switches to determine what output to write to sequence_to_species_similarity.txt
#	odo_status=0
#	phia_status=0

	#Code structure below is the same for each of the 6 genes
	##Grep all lines with the word "Identities", isolate the alignment length and percent identity. Then sort first on length, then on identity and finaly keep only top hit (highest identity for longest length)
#	rpb2_Odo_stats=$(grep "Identities" ./"$strain_name_res"/rpb2_Odo."$strain_name"*.out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 --numeric -r | head -n1)
#	#strain_rpb2_Odo_length=$(echo "$rpb2_Odo_stats" | cut -d $'\t' -f1) #Isolate alignment length
#	rpb2_Odo_iden=$(echo "$rpb2_Odo_stats" | cut -d $'\t' -f2) #Isolate percent identity
	
#	rpb1_Odo_stats=$(grep "Identities" ./"$strain_name_res"/rpb1_Odo_corrected."$strain_name"*.out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 --numeric -r | head -n1)
#	strain_rpb1_Odo_length=$(echo "$rpb1_Odo_stats" | cut -d $'\t' -f1) #Isolate alignment length
#	rpb1_Odo_iden=$(echo "$rpb1_Odo_stats" | cut -d $'\t' -f2) #Isolate percent identity
															        
#	tef1_Odo_stats=$(grep "Identities" ./"$strain_name_res"/tef1_Odo."$strain_name"*.out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort --numeric -k1,1 -r | head -n1)
#	strain_tef1_Odo_length=$(echo "$tef1_Odo_stats" | cut -d $'\t' -f1) #Isolate alignment length
#	tef1_Odo_iden=$(echo "$tef1_Odo_stats" | cut -d $'\t' -f2) #Isolate percent identity

#	if [ "$strain_rpb2_Odo_length" -ge "$rpb2_length" ] && [ "$rpb2_Odo_iden" -ge "$minimum_identity" ]; then #Check if alignement length is long enough and similarity is equal to or higher than thershold value
#		if [ "$strain_rpb1_Odo_length" -ge "$rpb1_length" ] && [ "$rpb1_Odo_iden" -ge "$minimum_identity" ]; then #Check if alignement length is long enough and similarity is equal to or higher than thershold value
#			if [ "$strain_tef1_Odo_length" -ge "$tef1_length" ] && [ "$tef1_Odo_iden" -ge "$minimum_identity" ]; then
#				odo_status=1
#				echo "$strain_name is at least $minimum_identity% similar to all three Odoratissimum genes"
#				echo "$strain_name has $rpb2_Odo_iden $rpb1_Odo_iden $tef1_Odo_iden percent identity to the Odoratissimum genes (rpb2, rpb1, tef1)" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_similarity_summary.txt
#			fi
#		fi
#	fi
#																																													        
#	if [ "$strain_tef1_Odo_length" -lt "$tef1_length" ]; then
#		echo "$strain_name tef1 Odo alignment is too short!"
#		echo "$strain_name tef1 Odo alignment is too short! $strain_tef1_Odo_length" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_short_alignments.txt
#	fi

#	if [ "$strain_rpb1_Odo_length" -lt "$rpb1_length" ]; then
#		echo "$strain_name rpb1 Odo alignment is too short!"
#		echo "$strain_name rpb1 Odo alignment is too short! $strain_rpb1_Odo_length" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_short_alignments.txt
#	fi

#	if [ "$strain_rpb2_Odo_length" -lt "$rpb2_length" ]; then
#		echo "$strain_name rpb2 Odo alignment is too short!"
#		echo "$strain_name rpb2 Odo alignment is too short! $strain_rpb2_Odo_length" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_short_alignments.txt
#	fi

	#Code structure below is the same for each of the 6 genes
#	##Grep all lines with the word "Identities", isolate the alignment length and percent identity. Then sort first on length, then on identity and finaly keep only top hit (highest identity for longest length)
#	rpb2_phia_stats=$(grep "Identities" ./"$strain_name_res"/rpb2_phia."$strain_name"*.out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 --numeric -r | head -n1)
#	strain_rpb2_phia_length=$(echo "$rpb2_phia_stats" | cut -d $'\t' -f1) #Isolate alignment length
	#rpb2_phia_iden=$(echo "$rpb2_phia_stats" | cut -d $'\t' -f2) #Isolate percent identity
	
#	rpb1_phia_stats=$(grep "Identities" ./"$strain_name_res"/rpb1_Phia_corrected."$strain_name"*.out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 --numeric -r | head -n1)
#	strain_rpb1_phia_length=$(echo "$rpb1_phia_stats" | cut -d $'\t' -f1) #Isolate alignment length
#	rpb1_phia_iden=$(echo "$rpb1_phia_stats" | cut -d $'\t' -f2) #Isolate percent identity
	
#	tef1_phia_stats=$(grep "Identities" ./"$strain_name_res"/tef1_phia."$strain_name"*.out | awk '{print $3 "\t" $4}' | cut -d "/" -f1,2 | cut -d "%" -f1 | sed 's/(//g' | sed 's/\//\t/g' | cut -d $'\t' -f2,3 |sort -k1,1 -r --numeric | head -n1)
#	strain_tef1_phia_length=$(echo "$tef1_phia_stats" | cut -d $'\t' -f1) #Isolate alignment length
#	tef1_phia_iden=$(echo "$tef1_phia_stats" | cut -d $'\t' -f2) #Isolate percent identity

#	if [ "$strain_rpb2_phia_length" -ge "$rpb2_length" ] && [ "$rpb2_phia_iden" -ge "$minimum_identity" ]; then #Check if alignement length is long enough and similarity is equal to or higher than thershold value
#		if [ "$strain_rpb1_phia_length" -ge "$rpb1_length" ] && [ "$rpb1_phia_iden" -ge "$minimum_identity" ]; then #Check if alignement length is long enough and similarity is equal to or higher than thershold value
#			if [ "$strain_tef1_phia_length" -ge "$tef1_length" ] && [ "$tef1_phia_iden" -ge "$minimum_identity" ]; then
#				phia_status=1
#				echo "$strain_name is at least $minimum_identity% similar to all three phialophorum genes"
#				echo "$strain_name has $rpb2_phia_iden $rpb1_phia_iden $tef1_phia_iden percent identity to the Phialophorum genes (rpb2, rpb1, tef1)" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_similarity_summary.txt
#			fi
#		fi
#	fi
	
#	if [ "$strain_tef1_phia_length" -lt "$tef1_length" ]; then
#		echo "$strain_name tef1 phia alignment is too short!"
#		echo "$strain_name tef1 phia alignment is too short! $strain_tef1_phia_length" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_short_alignments.txt
#	fi

#	if [ "$strain_rpb1_phia_length" -lt "$rpb1_length" ]; then
#		echo "$strain_name rpb1 phia alginment is too short!"
#		echo "$strain_name rpb1 phia alignment is too short! $strain_rpb1_phia_length" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_short_alignments.txt
#	fi

#	if [ "$strain_rpb2_phia_length" -lt "$rpb2_length" ]; then
#		echo "$strain_name rpb2 phia alignment is too short!"
#		echo "$strain_name rpb2 phia alignment is too short! $strain_rpb2_phia_length" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_short_alignments.txt
#	fi

#	echo "$strain_name has rpb2 $strain_rpb2_Odo_length $rpb2_Odo_iden rpb1 $strain_rpb1_Odo_length $rpb1_Odo_iden tef1 $strain_tef1_Odo_length $tef1_Odo_iden percent identity to the Odoratissimum genes" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_all_identities.txt
#	echo "$strain_name has rpb2 $strain_rpb2_phia_length $rpb2_phia_iden rpb1 $strain_rpb1_phia_length $rpb1_phia_iden tef1 $strain_tef1_phia_length $tef1_phia_iden percent identity to the Phialophorum genes" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_all_identities.txt
#
#	if [ "$odo_status" -eq 1 ] && [ "$phia_status" -eq 1 ]; then
#		echo "$strain_name      Both" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_sequence_to_species_similarity.txt
#	elif [ "$odo_status" -eq 1 ]; then
#		echo "$strain_name      odoratissimum" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_sequence_to_species_similarity.txt
#	elif [ "$phia_status" -eq 1 ]; then
#		echo "$strain_name      phialophorum" >> ~/h/BLAST/PurOdoPhia_Blast/corrected_sequence_to_species_similarity.txt
#	fi
	
#	echo " "

#done
