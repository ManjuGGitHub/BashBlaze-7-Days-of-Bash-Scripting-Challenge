#!/bin/bash

echo "Welcome to the Interactive File and Directory Explorer!"

#Listing all files and directories to all_files file

ls $pwd >all_files
#Create Array and add all the files and directory to that array
readarray -t files <all_files

#Print file name and its size in Human Readable format
for file in ${files[@]};do
     du -h $file | awk '{print $2,"(",$1,")"}'
done

#$User interactive script to get the input and print word count, We can use wc also to count words
while true;do

        read -p "Enter a line of text (Press Enter without text to exit): " user_input
        echo ""
        if [[ -z "$user_input" ]];then
                echo "Exiting the Interactive Explorer. Goodbye!"
                break
        else
                echo "Character Count: ${#user_input}"
                echo ""
        fi

done
