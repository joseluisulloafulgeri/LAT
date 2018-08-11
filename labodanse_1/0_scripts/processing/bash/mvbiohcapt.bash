#! /bin/bash
# put files one step up in the hierarchy,
# JLUF 31/10/2014
# usage: 
# in BioH_0914_october
# do: ../../0_scripts/1_mv_files_bioh.bash >& 1_mv_files_bioh.log

#for i_elem in S476 S573 S719 S749 S804 S810 S812 S819 S825 S828 S846 S828_bis_postDebranchage
#for i_elem in TEST_1 TEST_2
# for i_elem in 476 573 719 749 804 810 812 819 825 828 846

for i_elem in 476 573 719 749 749BIS 804 810 812 819 825 828 846

do
	cd ${i_elem}
	mv No\ Team\ Assigned File_1
		cd File_1
			for i in `ls`
			do
				echo ${i}
				mv ${i} ../
			done
		cd ..
		#rm File_1
	cd ../
done

# END
