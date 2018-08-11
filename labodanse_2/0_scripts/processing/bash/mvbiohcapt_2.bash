#! /bin/bash
# put files one step up in the hierarchy,
# JLUF 31/10/2014
# usage: 
# in BioH_0914_october
# do: ../../0_scripts/1_mv_files_bioh.bash >& 1_mv_files_bioh.log

for i_elem in 476 719 749 804 810 812 819 825 828 846

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
