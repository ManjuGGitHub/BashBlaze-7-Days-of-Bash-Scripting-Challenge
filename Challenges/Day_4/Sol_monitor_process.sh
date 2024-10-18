#!/bin/bash

#function to check given process is running or not
function is_processRunning(){
        if pgrep -x "$1";then
                return 0
        else
                return 1
        fi
}

#Function to restart the process
function restartProcess(){
        local process="$1"
        echo "$process is not Running. Attempting to start $process process"

        #starting process
        if sudo systemctl start "$process";then
                echo "$process Process starting now"
        else
                echo "$process Failed to start... reattempting again."
        fi

}

maximumAttempt=3
attempt=1

#Maximum 3 attempts to it will check, If process is running then it will exit else it will try for another time and try to restrat process
while [ $attempt -lt $maximumAttempt ];do
        if is_processRunning "$1";then
                echo "$1 Process is running."
                exit
        else
                restartProcess "$1"
        fi

        attempt=$((attempt + 1))

        sleep 5
done
#If the process failed to restart in maximum 3 attempts then it will print user message to check manually.
echo "Maximum restart attempts failed, please check process manually"
