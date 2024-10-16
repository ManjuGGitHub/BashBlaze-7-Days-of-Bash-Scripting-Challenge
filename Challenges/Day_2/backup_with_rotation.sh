#!/bin/bash
#Author: Manjunath Gudur
##Created Time: 15/10/2024
#Last Modified Time: 16/10/2024

if [[ $# -eq 0 ]] || [[ ! -d "$1" ]];
then
        echo "Please provide valid directory path which you want to take backup:"
        exit
fi

#argument passed by user will be source directory for which need to take backup
source_dir="$1"

#Function to create backup of particular Directory provided by User as command line argument
function create_backup {
        local timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
        backup_dir="${source_dir}/backup/backup_${timestamp}"
        zip -r  "${backup_dir}.zip" "${source_dir}" >/dev/null

        if [[ $? -eq 0 ]];
        then
                echo "Backup created successfully: ${backup_dir}.zip"
        else
                echo "Backup failed to create."
        fi
}

#Rotational backup - it will only keep latest 3 backups and delete other backups
function backup_rotation {
        backups=($(ls -t "${source_dir}/backup/backup_"*.zip 2>/dev/null))

        if [[ ${#backups[@]} -gt 3 ]];then
                backups_to_remove="${backups[@]:3}"
                for backup in $backups_to_remove;do
                        rm -r $backup
                        echo "Old backup ${backup} deleted as per retention policy!"
                done
        fi
}
#Function calling to create backup of given directory
create_backup
#function to Perform rotational backup
backup_rotation
