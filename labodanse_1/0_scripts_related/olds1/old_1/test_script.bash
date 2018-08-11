#! /bin/bash
# testing transference of files
# JLUF 31/10/2014
# usage: 
# in BioH_0914_october
# do: ../../test_script.bash

#for i_elem in {'S476' 'S573' 'S719' 'S749' 'S804' 'S810' 'S812' 'S819' 'S825' 'S828' 'S846'}
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





