#! /bin/bash
set -m
# relocate png files according to the tree structure
# JLUF 17/02/2015
# usage:
# in 2_data_analysis/bioharness/bioharness_3
# or 2_data_analysis/bioharness/bioharness_4
# do: ../../../0_scripts/Scripts_Struct/Analysis/relocatefilesbioharness.bash >& relocatefilesbioharness.log

# type of representation
############################
#typeData="MC"
typeData="nMC"
File1="OverallByDance"
File2="Each1minute"
############################

# first the wholeW data

# alternative to mv
# mv *wholeW*.png $File1
find ./ -maxdepth 1 -name "*wholeW*.png" -exec mv {} $File1 \;

cd $File1

if [ "$typeData" == "MC" ]
then
	mv MC1*BR*.png BR_MC1
	mv MC2*BR*.png BR_MC2
	mv MC1*HR*.png HR_MC1
	mv MC2*HR*.png HR_MC2 
else
	mv nMC1*BR*.png BR_nMC1
	mv nMC2*BR*.png BR_nMC2
	mv nMC1*HR*.png HR_nMC1
	mv nMC2*HR*.png HR_nMC2
fi

if [ "$typeData" == "MC" ]
then
	for i_folder in BR_MC1 BR_MC2 HR_MC1 HR_MC2
	do
		cd ${i_folder}
		mv *session1*.png session1
		mv *session2*.png session2
		mv *session3*.png session3
		mv *session4*.png session4

		cd ../
	done

else
	for i_folder in BR_nMC1 BR_nMC2 HR_nMC1 HR_nMC2
	do
		cd ${i_folder}
		mv *session1*.png session1
		mv *session2*.png session2
		mv *session3*.png session3
		mv *session4*.png session4
		cd ../
	done
fi

cd ../

# second the selected windows

# alternative to mv
find ./ -maxdepth 1 -name "*.png" -exec mv {} $File2 \;

#mv *.png $File2
cd $File2

if [ "$typeData" == "MC" ]
then
	mv MC1*BR*.png BR_MC1
	mv MC2*BR*.png BR_MC2
	mv MC1*HR*.png HR_MC1
	mv MC2*HR*.png HR_MC2 
else
	mv nMC1*BR*.png BR_nMC1
	mv nMC2*BR*.png BR_nMC2
	mv nMC1*HR*.png HR_nMC1
	mv nMC2*HR*.png HR_nMC2 
fi

if [ "$typeData" == "MC" ]
then
	for i_folder in BR_MC1 BR_MC2 HR_MC1 HR_MC2
	do
		cd ${i_folder}
		mv *session1*.png session1
		mv *session2*.png session2
		mv *session3*.png session3
		mv *session4*.png session4

		for x_folder in session1 session2 session3 session4
		do
			cd ${x_folder}
			mv *duo_1*.png duo_1
			mv *duo_2*.png duo_2
			mv *solo_1*.png solo_1
			mv *solo_2*.png solo_2
			cd ../
		done
		cd ../
	done
else
	for i_folder in BR_nMC1 BR_nMC2 HR_nMC1 HR_nMC2
	do
		cd ${i_folder}
		mv *session1*.png session1
		mv *session2*.png session2
		mv *session3*.png session3
		mv *session4*.png session4

		for x_folder in session1 session2 session3 session4
		do
			cd ${x_folder}
			mv *duo_1*.png duo_1
			mv *duo_2*.png duo_2
			mv *solo_1*.png solo_1
			mv *solo_2*.png solo_2

			cd ../
		done
		cd ../
	done
fi

# END
