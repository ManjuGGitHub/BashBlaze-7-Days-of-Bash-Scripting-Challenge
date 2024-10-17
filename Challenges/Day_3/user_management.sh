#!/bin/bash

function displayUsage() {

echo "Usage: $0 [OPTIONS]"
echo "Options: "

echo "-c, --create      Create user account"
echo "-d, --delete      Delete user account"
echo "-r, --reset       Reset password for existing user"
echo "-l, --list        List all existing User accounts"
echo "-h, --help        Display this help and exit"

read -p "Enter what you would like to perform from above [OPTIONS]: " choice

}

function createUser(){
        read -p "Enter new username you want to create: " username

        if id $username;then
                echo  "$username user is already exist. Please provide new username you want to create"
                displayUsage
        else
                read -p "Enter password for $username : " password

                #create username with password
                sudo useradd -m -p "$password" "$username"
                if [[ $? -eq 0 ]];then
                        echo ""
                        echo "User account $username is created successfully."
                        #Once user is created then user will be prompted to ask what user wants to do next
                        displayUsage
                else
                        echo "Sorry! $username not created because of some error."
                fi
        fi
}

function deleteUser(){
        read -p "Enter username you want to Delete: " username

        if id $username;then
                #Delete username
                sudo userdel "$username"
                if [[ $? -eq 0 ]];then
                        echo "User account $username is Deleted successfully."
                        #Once user is deleted then prompt will ask User wants to do next by displaying all the available options
                        displayUsage
                else
                        echo "Sorry! $username not Deleted because of some error."
                fi
        else
                echo "User account $username is not active available user"
                #Will prompt user to provide correct username to delete from available user list
                deleteUser
        fi
}

function reset_password {
    read -p "Enter the username to reset password: " username

    # Check if the username exists
    if id "$username" &>/dev/null; then
        # Prompt for password (Note: You might want to use 'read -s' to hide the password input)
        read -p "Enter the new password for $username: " password

        # Set the new password
        echo "$username:$password" | chpasswd
        echo "Password for user '$username' reset successfully."
        #Once password is reset then prompt will ask user to provide input for next oparation
        displayUsage
    else
        echo "Error: The username '$username' does not exist. Please enter a valid username."
        exit
    fi
}

function listUser(){
        echo "All Avaialable Users are: "
        cat /etc/passwd | awk -F: '{print $1}'
}

#Calling displayUsage function to prompt all the available option
displayUsage

#Takes user input and based on that it will perform user management
while true;
do
        if [ $choice == 'c' ];then
        createUser
        elif [ $choice == 'd' ];then
        deleteUser
        elif [ $choice == 'l' ];then
        listUser
        elif [ $choice == 'r' ];then
        resetPasswd
        else
                echo "Exiting!! Thank You"
                exit
        fi
done
