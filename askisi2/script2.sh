#!/bin/bash

mkdir repositories #Clone repos here
tar -xC . -f "$1" #Unzip tar.gz
#Clone repositories
for file in $(find -type f -name '*.txt') #Read only text file. Ignore all else
do
    while IFS= read -r link 
    do
           if [[ ${link:0:1} != "#" ]] #Ignore line if it starts with #
           then
            if [[ ${link::5} == "https" ]] #Grab the first line that is link
            then
                cd repositories
                
                # git clone --quiet "$link" &> /dev/null #Clone repo to file
                if [ $? -eq 0 ]; #Report if cloning was succesful
                then
                      echo "$link: Cloning OK" 
                else
                    echo "$link: Cloning FAILED" >&2 
                fi
                cd ..        
                #Exit repositories directory
                continue
            fi
        fi
        
    done < $file
done
#End of cloning process
cd repositories

#Check which repositories follow the correct structure
for dir in */
do    
    cd $dir #Enter repo directory
    dir=${dir%*/} #Print repo name
    echo "$dir:"
    
    dirs_num=$(find . -not -iwholename '*.git*' -not -path '.' -type d) #Number of subdirectories in repo
    txt_num=$(find . -type f -name "*.txt") #Number of txt files in repo
    other_num=$(find . -not -iwholename '*.git*' -not -name "*.txt" -not -path '.' -not -type d) #Number of rest elements
    
    echo "Number of directories: $dirs_num"
    echo "Number of txt files: $txt_num"
    echo "Number of other files: $other_num"
    if [[ $other_num != 0 ]] || [[ $dirs_num != 1 ]] || [[ $txt_num != 3 ]] #Check if numbers are correct
    then
        echo "Directory structure is NOT OK."
    else
        if [ -e ./dataA.txt ] #Check if dataA.txt exists
        then
            if [ -d more ] #Check if ./more subdirectory exists
            then
                cd more #Enter more directory
                if [ -e ./dataB.txt ] && [ -e ./dataC.txt ] #Check if both dataB.txt and DataC.txt exist
                then
                    echo "Directroy structure is OK." 
                else
                    echo "Directory structure is NOT OK."
                fi
                cd .. #Exit ./more
            else
                echo "Directory structure is NOT OK."
            fi
        else
            echo "Directory structure is NOT OK."
        fi
    fi
    cd .. #Exit repo
done
