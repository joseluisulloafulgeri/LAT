#! /bin/bash
# JLUF 04/11/2014

# NOT USED; made by hand

# usage:
# in donnes_tablettes_Octobre
# do: ../../0_scripts/3_rename_files_tablette.bash >& 3_rename_files_tablette.log

# for i_elem in {'104' '106' '476' '476' '749' '804' '810' '812' '819' '825' '828' '846'}
for i_elem in S_TEST

do
    cd ${i_elem}
	mv No\ Team\ Assigned ${i_elem}
		cd ${i_elem}
#			obj=`ls`
				for i in `ls`
					do
						echo ${i}
						mv ${i_elem}/${i} ../
					done
done
