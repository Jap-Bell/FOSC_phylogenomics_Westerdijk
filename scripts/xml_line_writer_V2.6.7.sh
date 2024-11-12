#!/bin/bash

#Variables
#1.	$Gene_ID 	== file name without extension
#2.	$Strain		== one of 231 strains included in tree as written there, including “busco”
#3.	$Gene_Nr	== the index of the gene used, so the sequences get unique IDs  Counter
#4.	$Gene_Seq	== the gene sequence for the specific strain

Gene_Nr=0
Gene_Seq=""
Sequences_Anouk="/home/j.bell_cbs-niob.local/g/Group Crous/000INTERNS/Jasper/Sequences_Anouk"
path="/home/j.bell_cbs-niob.local/g/Group Crous/000INTERNS/Jasper/Sequences_Anouk/Species_tree/STACEY/RanSubset/"

##############################################################################################################################################################################################################################
###########################################################################       PRESETS	##############################################################################################################################
##############################################################################################################################################################################################################################

echo "<beast beautitemplate=\"STACEY\" beautistatus=\"\" namespace=\"beast.core:beast.evolution.alignment:beast.evolution.tree.coalescent:beast.core.util:beast.evolution.nuc:beast.evolution.operators:beast.evolution.sitemodel:beast.evolution.substitutionmodel:beast.evolution.likelihood\" required=\"\" version=\"2.6\">" >> "$path/1_Start_Data_Sequences.xml"

echo "<distribution id=\"posterior\" spec=\"util.CompoundDistribution\">" >> "$path/6_run_distribution.xml"
echo "<distribution id=\"smcCoalescent\" spec=\"stacey.PIOMSCoalescentDistribution\" popPriorScale=\"@popPriorScale\" taxonset=\"@taxonsuperset\" tree=\"@Tree.t:Species\">" >> "$path/6_run_distribution.xml"

echo "<distribution id=\"likelihood\" spec=\"util.CompoundDistribution\">" >> "$path/8_run_CompoundDistribution.xml" 

echo "<operator id=\"StaceyNodeReheight.t:Species\" spec=\"stacey.StaceyNodeReheight\" popSF=\"@popPriorScale\" smcTree=\"@Tree.t:Species\" weight=\"60.0\">" >> "$path/9_run_geneTree.xml"

echo "<operator id=\"NodesNudge.t:Species\" spec=\"stacey.NodesNudge\" smcTree=\"@Tree.t:Species\" weight=\"20.0\">" >> "$path/10_run_NodesNudge.xml"

echo "<operator id=\"FocusedNodeHeightScaler.t:Species\" spec=\"stacey.FocusedNodeHeightScaler\" smcTree=\"@Tree.t:Species\" weight=\"20.0\">" >> "$path/11_run_FNHS.xml"

echo "<operator id=\"CoordinatedPruneRegraft.t:Species\" spec=\"stacey.CoordinatedPruneRegraft\" smcTree=\"@Tree.t:Species\" weight=\"20.0\">" >> "$path/12_run_CPR.xml"

echo "<operator id=\"ThreeBranchAdjuster.t:Species\" spec=\"stacey.ThreeBranchAdjuster\" popSF=\"@popPriorScale\" smcTree=\"@Tree.t:Species\" weight=\"20.0\">" >> "$path/13_run_TBA.xml" 

echo "<operator id=\"popPriorScaleScale.t:Species\" spec=\"ScaleOperator\" parameter=\"@popPriorScale\" weight=\"3.0\"/>" >> "$path/14_run_PPSS_updown100.xml"
echo "<operator id=\"updown.100.all.Species\" spec=\"UpDownOperator\" optimise=\"false\" scaleFactor=\"0.1\" weight=\"2.0\">" >> "$path/14_run_PPSS_updown100.xml"
echo " <up idref=\"bdcGrowthRate.t:Species\"/>" >> "$path/14_run_PPSS_updown100.xml"
echo " <down idref=\"Tree.t:Species\"/>" >> "$path/14_run_PPSS_updown100.xml"
echo " <down idref=\"originHeight.t:Species\"/>" >> "$path/14_run_PPSS_updown100.xml" 

echo "<operator id=\"updown.350.all.Species\" spec=\"UpDownOperator\" optimise=\"false\" scaleFactor=\"0.35\" weight=\"2.0\">" >> "$path/15_run_updown350.xml"
echo " <up idref=\"bdcGrowthRate.t:Species\"/>" >> "$path/15_run_updown350.xml"
echo " <down idref=\"Tree.t:Species\"/>" >> "$path/15_run_updown350.xml"
echo " <down idref=\"originHeight.t:Species\"/>" >> "$path/15_run_updown350.xml"

echo "<operator id=\"updown.700.all.Species\" spec=\"UpDownOperator\" optimise=\"false\" scaleFactor=\"0.7\" weight=\"2.0\">" >> "$path/16_run_updown700.xml"
echo " <up idref=\"bdcGrowthRate.t:Species\"/>" >> "$path/16_run_updown700.xml"
echo " <down idref=\"Tree.t:Species\"/>" >> "$path/16_run_updown700.xml"
echo " <down idref=\"originHeight.t:Species\"/>" >> "$path/16_run_updown700.xml"

echo "<operator id=\"updown.900.all.Species\" spec=\"UpDownOperator\" optimise=\"false\" scaleFactor=\"0.9\" weight=\"2.0\">" >> "$path/17_run_updown900.xml"
echo " <up idref=\"bdcGrowthRate.t:Species\"/>" >> "$path/17_run_updown900.xml"
echo " <down idref=\"Tree.t:Species\"/>" >> "$path/17_run_updown900.xml"
echo " <down idref=\"originHeight.t:Species\"/>" >> "$path/17_run_updown900.xml"

echo "<operator id=\"updown.970.all.Species\" spec=\"UpDownOperator\" optimise=\"false\" scaleFactor=\"0.97\" weight=\"2.0\">" >> "$path/18_run_updown970.xml"
echo " <up idref=\"bdcGrowthRate.t:Species\"/>" >> "$path/18_run_updown970.xml"
echo " <down idref=\"Tree.t:Species\"/>" >> "$path/18_run_updown970.xml"
echo " <down idref=\"originHeight.t:Species\"/>" >> "$path/18_run_updown970.xml"

echo "<operator id=\"updown.990.all.Species\" spec=\"UpDownOperator\" optimise=\"false\" scaleFactor=\"0.99\" weight=\"2.0\">" >> "$path/19_run_updown990.xml"
echo " <up idref=\"bdcGrowthRate.t:Species\"/>" >> "$path/19_run_updown990.xml"
echo " <down idref=\"Tree.t:Species\"/>" >> "$path/19_run_updown990.xml"
echo " <down idref=\"originHeight.t:Species\"/>" >> "$path/19_run_updown990.xml"

echo "<operator id=\"updown.997.all.Species\" spec=\"UpDownOperator\" optimise=\"false\" scaleFactor=\"0.997\" weight=\"2.0\">" >> "$path/20_run_updown997.xml"
echo " <up idref=\"bdcGrowthRate.t:Species\"/>" >> "$path/20_run_updown997.xml"
echo " <down idref=\"Tree.t:Species\"/>" >> "$path/20_run_updown997.xml"
echo " <down idref=\"originHeight.t:Species\"/>" >> "$path/20_run_updown997.xml"

echo "<operator id=\"updown.999.all.Species\" spec=\"UpDownOperator\" optimise=\"false\" scaleFactor=\"0.999\" weight=\"2.0\">" >> "$path/21_run_updown999.xml"
echo " <up idref=\"bdcGrowthRate.t:Species\"/>" >> "$path/21_run_updown999.xml"
echo " <down idref=\"Tree.t:Species\"/>" >> "$path/21_run_updown999.xml"
echo " <down idref=\"originHeight.t:Species\"/>" >> "$path/21_run_updown999.xml"

echo "<logger id=\"tracelog\" spec=\"Logger\" fileName=\"26at5125_trimmed.log\" logEvery=\"5000\" model=\"@posterior\" sort=\"smart\">" >> "$path/25_Tracelog.xml"
echo "<log idref=\"posterior\"/>" >> "$path/25_Tracelog.xml"
echo "<log idref=\"likelihood\"/>" >> "$path/25_Tracelog.xml"
echo "<log idref=\"prior\"/>" >> "$path/25_Tracelog.xml"
echo "<log idref=\"smcCoalescent\"/>" >> "$path/25_Tracelog.xml"
echo "<log idref=\"bdcGrowthRate.t:Species\"/>" >> "$path/25_Tracelog.xml"
echo "<log idref=\"relativeDeathRate.t:Species\"/>" >> "$path/25_Tracelog.xml"
echo "<log idref=\"collapseWeight.t:Species\"/>" >> "$path/25_Tracelog.xml"
echo "<log idref=\"originHeight.t:Species\"/>" >> "$path/25_Tracelog.xml"
echo "<log idref=\"popPriorScale\"/>" >> "$path/25_Tracelog.xml"
echo "<log id=\"PopSampleStatistic.0\" spec=\"stacey.PopSampleStatistic\" piomsCoalDist=\"@smcCoalescent\" popPriorScale=\"@popPriorScale\"/>" >> "$path/25_Tracelog.xml"
echo "<log id=\"BirthDeathCollapseNClustersStatistic.0\" spec=\"stacey.BirthDeathCollapseNClustersStatistic\" bdcm=\"@BirthDeathCollapseModel.t:Species\" smcTree=\"@Tree.t:Species\"/>" >> "$path/25_Tracelog.xml"
echo "<log idref=\"BirthDeathCollapseModel.t:Species\"/>" >> "$path/25_Tracelog.xml"
echo "<log id=\"TreeHeight.Species\" spec=\"beast.evolution.tree.TreeHeightLogger\" tree=\"@Tree.t:Species\"/>" >> "$path/25_Tracelog.xml" 

echo "<logger id=\"speciesTreeLogger\" spec=\"Logger\" fileName=\"species.trees\" logEvery=\"5000\" mode=\"tree\">" >> "$path/26_Other_Loggers.xml"
echo "<log id=\"SpeciesTreeLoggerX\" spec=\"beast.evolution.tree.TreeWithMetaDataLogger\" tree=\"@Tree.t:Species\"/>" >> "$path/26_Other_Loggers.xml"
echo "</logger>" >> "$path/26_Other_Loggers.xml" 
echo "<logger id=\"screenlog\" spec=\"Logger\" logEvery=\"5000\" model=\"@posterior\">" >> "$path/26_Other_Loggers.xml"
echo "<log idref=\"posterior\"/>" >> "$path/26_Other_Loggers.xml"
echo "<log id=\"ESS.0\" spec=\"util.ESS\" arg=\"@posterior\"/>" >> "$path/26_Other_Loggers.xml"
echo "<log idref=\"likelihood\"/>" >> "$path/26_Other_Loggers.xml"
echo "<log idref=\"prior\"/>" >> "$path/26_Other_Loggers.xml"
echo "<log id=\"BirthDeathCollapseNClustersStatistic.1\" spec=\"stacey.BirthDeathCollapseNClustersStatistic\" bdcm=\"@BirthDeathCollapseModel.t:Species\" smcTree=\"@Tree.t:Species\"/>" >> "$path/26_Other_Loggers.xml"
echo "</logger>" >> "$path/26_Other_Loggers.xml"



##############################################################################################################################################################################################################################
###########################################################################    Looping over genes    #########################################################################################################################
##############################################################################################################################################################################################################################

Gene_Seq=""
Gene_nr=0

for MSA_file in ./*
do
	Gene_ID=$(echo "$MSA_file" | cut -d"." -f2 | cut -d"/" -f2)
	echo "Working on $Gene_ID"

	#1_Start_Data_Sequences.xml
	echo "<data id=\"$Gene_ID\" spec=\"Alignment\" name=\"alignment\">" >> "$path/1_Start_Data_Sequences.xml"	

	while IFS= read -r line
	do
		if [[ ${line:0:1} == ">" ]] ; then 
			if [[ "${#Gene_Seq}" -gt 0 ]] ; then 			#if makes sure I only start writing out when the first gene sequence is complete
				echo "  <sequence id=\"seq_$Strain$Gene_Nr\" spec=\"Sequence\" taxon=\"$Strain\" totalcount=\"4\" value=\"$Gene_Seq\"/>" >> "$path/1_Start_Data_Sequences.xml" 
			fi
	
			Strain=$(echo "$line" | cut -d">" -f2) #Defined after writing out because when I encounter the next ">" I need to write out using the old Strain name and sequence
			Gene_Seq=""	#Reset Gene_Seq
	
		else
			Gene_Seq+="$line" #append per line the gene sequence for Gene+Strain combination
		fi

	done < "$MSA_file"

	#Write out a final time, as there is no ">" at the end of the file to prompt writing out the final gene sequence otherwise
	echo "  <sequence id=\"seq_$Strain$Gene_Nr\" spec=\"Sequence\" taxon=\"$Strain\" totalcount=\"4\" value=\"$Gene_Seq\"/>" >> "$path/1_Start_Data_Sequences.xml"
	echo "</data>" >> "$path/1_Start_Data_Sequences.xml" #Close data part for each gene

	(( Gene_Nr+=1 )) #Increase Gene_Nr after each gene

	#4_run_TreeIDs.xml
	echo "  <tree id=\"Tree.t:$Gene_ID\" spec=\"beast.evolution.tree.Tree\" name=\"stateNode\">" >> "$path/4_run_TreeIDs.xml"
	echo "   <taxonset id=\"TaxonSet.$Gene_ID\" spec=\"TaxonSet\">" >> "$path/4_run_TreeIDs.xml"
	echo "    <alignment idref=\"$Gene_ID\"/>" >> "$path/4_run_TreeIDs.xml"
	echo "	</taxonset>" >> "$path/4_run_TreeIDs.xml"
	echo " </tree>" >> "$path/4_run_TreeIDs.xml"
	
	echo "<init id=\"RandomTree.t:Species\" spec=\"beast.evolution.tree.RandomTree\" estimate=\"false\" initial=\"@Tree.t:Species\" rootHeight=\"0.05\" taxonset=\"@taxonsuperset\">" >> "$path/4_run_TreeIDs.xml"
	echo " <populationModel id=\"ConstantPopulation0.Species\" spec=\"ConstantPopulation\">" >> "$path/4_run_TreeIDs.xml"
	echo "  <parameter id=\"randomPopSize.t:Species\" spec=\"parameter.RealParameter\" name=\"popSize\">0.05</parameter>" >> "$path/4_run_TreeIDs.xml"
	echo " </populationModel>" >> "$path/4_run_TreeIDs.xml"
	echo "</init>" >> "$path/4_run_TreeIDs.xml"
	
	#5_run_init.xml
	echo "<init id=\"RandomGeneTree.t:$Gene_ID\" spec=\"beast.evolution.speciation.RandomGeneTree\" initial=\"@Tree.t:$Gene_ID\" speciesTree=\"@Tree.t:Species\" taxa=\"@$Gene_ID\">" >> "$path/5_run_init.xml"
	echo " <populationModel id=\"RGTPopulationModel.t:$Gene_ID\" spec=\"ConstantPopulation\">" >> "$path/5_run_init.xml"
	echo "  <parameter id=\"RGTPopSize.t:$Gene_ID\" spec=\"parameter.RealParameter\" name=\"popSize\">0.05</parameter>" >> "$path/5_run_init.xml"
	echo " </populationModel>" >> "$path/5_run_init.xml"
	echo "</init>" >> "$path/5_run_init.xml"

	#6_run_distribution.xml
	echo  "<geneTree id=\"gTreeCF.t:$Gene_ID\" spec=\"stacey.GtreeAndCoalFactor\" tree=\"@Tree.t:$Gene_ID\"/>" >> "$path/6_run_distribution.xml"

	#8_run_CompoundDistribution.xml
	echo "<distribution id=\"treeLikelihood.$Gene_ID\" spec=\"TreeLikelihood\" data=\"@$Gene_ID\" tree=\"@Tree.t:$Gene_ID\">" >> "$path/8_run_CompoundDistribution.xml"
	echo " <siteModel id=\"SiteModel.s:$Gene_ID\" spec=\"SiteModel\">" >> "$path/8_run_CompoundDistribution.xml"
	echo "  <parameter id=\"mutationRate.s:$Gene_ID\" spec=\"parameter.RealParameter\" estimate=\"false\" name=\"mutationRate\">1.0</parameter>" >> "$path/8_run_CompoundDistribution.xml"
	echo "  <parameter id=\"gammaShape.s:$Gene_ID\" spec=\"parameter.RealParameter\" estimate=\"false\" name=\"shape\">1.0</parameter>" >> "$path/8_run_CompoundDistribution.xml"
	echo "  <parameter id=\"proportionInvariant.s:$Gene_ID\" spec=\"parameter.RealParameter\" estimate=\"false\" lower=\"0.0\" name=\"proportionInvariant\" upper=\"1.0\">0.0</parameter>" >> "$path/8_run_CompoundDistribution.xml"
	echo "  <substModel id=\"JC69.s:$Gene_ID\" spec=\"JukesCantor\"/>" >> "$path/8_run_CompoundDistribution.xml"
	echo " </siteModel>" >> "$path/8_run_CompoundDistribution.xml"

	echo " <branchRateModel id=\"StrictClock.c:$Gene_ID\" spec=\"beast.evolution.branchratemodel.StrictClockModel\">" >> "$path/8_run_CompoundDistribution.xml"
	echo "  <parameter id=\"clockRate.c:$Gene_ID\" spec=\"parameter.RealParameter\" estimate=\"false\" name=\"clock.rate\">1.0</parameter>" >> "$path/8_run_CompoundDistribution.xml"
	echo " </branchRateModel>" >> "$path/8_run_CompoundDistribution.xml"
	echo "</distribution>" >> "$path/8_run_CompoundDistribution.xml"
				
	#9_run_geneTree.xml
	echo " <geneTree idref=\"Tree.t:$Gene_ID\"/>" >> "$path/9_run_geneTree.xml"

	#10_run_NodesNudge.xml
	echo " <geneTree idref=\"Tree.t:$Gene_ID\"/>" >> "$path/10_run_NodesNudge.xml" 

	#11_run_FNHS.xml
	echo " <geneTree idref=\"Tree.t:$Gene_ID\"/>" >> "$path/11_run_FNHS.xml"

	#12_run_CPR.xml
	echo " <geneTree idref=\"Tree.t:$Gene_ID\"/>" >> "$path/12_run_CPR.xml"

	#13_run_TBA.xml
	echo " <geneTree idref=\"Tree.t:$Gene_ID\"/>" >> "$path/13_run_TBA.xml"

	#14_run_PPSS_updown100.xml
	echo "<down idref=\"Tree.t:$Gene_ID\"/>" >> "$path/14_run_PPSS_updown100.xml"

	#15_updown350.xml
	echo "<down idref=\"Tree.t:$Gene_ID\"/>" >> "$path/15_run_updown350.xml"

	#16_updown700.xml
	echo "<down idref=\"Tree.t:$Gene_ID\"/>" >> "$path/16_run_updown700.xml"
				
	#17_updown_900.xml
	echo "<down idref=\"Tree.t:$Gene_ID\"/>" >> "$path/17_run_updown900.xml"

	#18_updown_970.xml
	echo "<down idref=\"Tree.t:$Gene_ID\"/>" >> "$path/18_run_updown970.xml"

	#19_updown_990.xml
	echo "<down idref=\"Tree.t:$Gene_ID\"/>" >> "$path/19_run_updown990.xml"

	#20_updown_997.xml
	echo "<down idref=\"Tree.t:$Gene_ID\"/>" >> "$path/20_run_updown997.xml"

	#21_updown_999.xml
	echo "<down idref=\"Tree.t:$Gene_ID\"/>" >> "$path/21_run_updown999.xml"
				
	#23_treescalers.xml
	echo "<operator id=\"treeScaler.t:$Gene_ID\" spec=\"ScaleOperator\" scaleFactor=\"0.5\" tree=\"@Tree.t:$Gene_ID\" weight=\"3.0\"/>" >> "$path/23_treescaler.xml"
	echo "<operator id=\"treeRootScaler.t:$Gene_ID\" spec=\"ScaleOperator\" rootOnly=\"true\" scaleFactor=\"0.5\" tree=\"@Tree.t:$Gene_ID\" weight=\"3.0\"/>" >> "$path/23_treescaler.xml"
	echo "<operator id=\"UniformOperator.t:$Gene_ID\" spec=\"Uniform\" tree=\"@Tree.t:$Gene_ID\" weight=\"30.0\"/>" >> "$path/23_treescaler.xml"
	echo "<operator id=\"SubtreeSlide.t:$Gene_ID\" spec=\"SubtreeSlide\" tree=\"@Tree.t:$Gene_ID\" weight=\"15.0\"/>" >> "$path/23_treescaler.xml"
	echo "<operator id=\"narrow.t:$Gene_ID\" spec=\"Exchange\" tree=\"@Tree.t:$Gene_ID\" weight=\"15.0\"/>" >> "$path/23_treescaler.xml"
	echo "<operator id=\"wide.t:$Gene_ID\" spec=\"Exchange\" isNarrow=\"false\" tree=\"@Tree.t:$Gene_ID\" weight=\"3.0\"/>" >> "$path/23_treescaler.xml"
	echo "<operator id=\"WilsonBalding.t:$Gene_ID\" spec=\"WilsonBalding\" tree=\"@Tree.t:$Gene_ID\" weight=\"3.0\"/>" >> "$path/23_treescaler.xml"
	
	#25_Tracelog.xml
	echo "<log idref=\"treeLikelihood.$Gene_ID\"/>" >> "$path/25_Tracelog.xml"
	echo "<log id=\"TreeHeight.t:$Gene_ID\" spec=\"beast.evolution.tree.TreeHeightLogger\" tree=\"@Tree.t:$Gene_ID\"/>" >> "$path/25_Tracelog.xml"

	#26_Other_Loggers.xml
	echo "<logger id=\"treelog.t:$Gene_ID\" spec=\"Logger\" fileName=\"\$(tree).trees\" logEvery=\"5000\" mode=\"tree\">" >> "$path/26_Other_Loggers.xml"
	echo " <log id=\"TreeWithMetaDataLogger.t:$Gene_ID\" spec=\"beast.evolution.tree.TreeWithMetaDataLogger\" tree=\"@Tree.t:$Gene_ID\"/>" >> "$path/26_Other_Loggers.xml"
	echo "</logger>" >> "$path/26_Other_Loggers.xml"

	#Save the info from the header of the next gene
	Strain=$(echo "$line" | cut -d">" -f2) #Defined all the way at the end because when I encounter the next ">" I still need to write out the old Strain name, so it shouldn't be before the other one
	Gene_Seq=""

	(( Gene_Nr += 1 ))
	
done

##############################################################################################################################################################################################################################
###########################################################################	POST CLEAN UP 	##############################################################################################################################
##############################################################################################################################################################################################################################

echo "</state>" >> "$path/4_run_TreeIDs.xml"

echo "</distribution>" >> "$path/8_run_CompoundDistribution.xml"
echo "</distribution>" >> "$path/8_run_CompoundDistribution.xml"

echo "</operator>" >> "$path/9_run_geneTree.xml"

echo "</operator>" >> "$path/10_run_NodesNudge.xml"

echo "</operator>" >> "$path/11_run_FNHS.xml"

echo "</operator>" >> "$path/12_run_CPR.xml"

echo "</operator>" >> "$path/13_run_TBA.xml"

echo "<down idref=\"popPriorScale\"/>" >> "$path/14_run_PPSS_updown100.xml"
echo "</operator>" >> "$path/14_run_PPSS_updown100.xml"

echo "<down idref=\"popPriorScale\"/>" >> "$path/15_run_updown350.xml"
echo "</operator>" >> "$path/15_run_updown350.xml"

echo "<down idref=\"popPriorScale\"/>" >> "$path/16_run_updown700.xml"
echo "</operator>" >> "$path/16_run_updown700.xml"

echo "<down idref=\"popPriorScale\"/>" >> "$path/17_run_updown900.xml"
echo "</operator>" >> "$path/17_run_updown900.xml"

echo "<down idref=\"popPriorScale\"/>" >> "$path/18_run_updown970.xml"
echo "</operator>" >> "$path/18_run_updown970.xml"

echo "<down idref=\"popPriorScale\"/>" >> "$path/19_run_updown990.xml"
echo "</operator>" >> "$path/19_run_updown990.xml"

echo "<down idref=\"popPriorScale\"/>" >> "$path/20_run_updown997.xml"
echo "</operator>" >> "$path/20_run_updown997.xml"

echo "<down idref=\"popPriorScale\"/>" >> "$path/21_run_updown999.xml"
echo "</operator>" >> "$path/21_run_updown999.xml"

echo "</logger>" >> "$path/25_Tracelog.xml"

echo "</run>" >> "$path/26_Other_Loggers.xml"
echo "</beast>" >> "$path/26_Other_Loggers.xml"
