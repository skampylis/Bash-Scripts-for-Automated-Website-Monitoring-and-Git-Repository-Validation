#!/bin/bash

function checker {
	name="${1////-}" #Replace / with - because files can't have /
	#If link exists in stored then it has been used before
	if grep -q "$1" stored; then
		mv "${name}new" "${name}old" 2> /dev/null #Rename the file from previous execution
   		curl $1 -L --compressed -s > "${name}new"
    		differences="$(diff "${name}new" "${name}old")" #Check if new and old file are the same
        	if [ "0" != "${#diffrerences}" ]; then
			check= wc -m "${name}new" #If there has been a problem the file is empty
		 	if [ "0" == "$check" ]; then
				>&2 echo "$1 FAILED" #Failed to reach site
			else 
				echo "$1" #There has been a change
			fi
            	fi
            	rm "${name}old" #Nothing changed. Remove old file
	else 
	#First time used link
		touch "${name}new"
		curl $1 -L --compressed -s > "${name}new" #Send data to {name}new
		echo "$1" >> stored
       	echo "$1 INIT" #Print on terminal 
        fi
}

touch stored #Touch stored if it doesn't exist
while IFS= read -r link
do
	if [[ ${link:0:1} == "#" ]]; then #Ignore line if first letter is #
   		continue
	fi
	checker $link #Call checker function
done < "$1"
