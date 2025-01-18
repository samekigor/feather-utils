#!/bin/bash
#
#
#
# This script creates user and group for Feather System.
# All of the details are in the .yaml file which is provded in FEATHER_CONFIG_FILE_PATH enviroment variable.
#
# Requirements:
# - env vars:
#       -FEATHER_CONFIG_FILE_PATH
# - yq
# - sudo command 

#Create group and user called feather
FEATHER_USER="feather"
FEATHER_GROUP="feather"



if getent group "$FEATHER_GROUP" > /dev/null 2>&1; then
    echo "Group $FEATHER_GROUP exists"
else
    if groupadd "$FEATHER_GROUP"; then
        sudo groupadd $FEATHER_GROUP
        echo "Created group $FEATHER_GROUP."
    else
        echo "Failutre with creation $FEATHER_GROUP."
        exit 1
    fi
fi

# echo $FEATHER_CONFIG_FILE_PATH
DEFAULT_DICT=$(yq eval '.default-system-dir.path' "$FEATHER_CONFIG_FILE_PATH")
# echo $DEFAULT_DICT

#Create default directory
if [ -d "$DEFAULT_DICT" ]; then
    echo "The folder $DEFAULT_DICT already exists."
else
    sudo mkdir -p "$DEFAULT_DICT"
    echo "The folder $DEFAULT_DICT has been created."
fi

# Add the user to the specified group with the desired settings
if ! id -u "$FEATHER_USER" > /dev/null 2>&1; then
    echo "Creating user $FEATHER_USER..."
    sudo useradd -r -g "$FEATHER_GROUP" -s /usr/sbin/nologin -d "$DEFAULT_DICT" "$FEATHER_USER"
    echo "User $FEATHER_USER created successfully."
else
    echo "User $FEATHER_USER already exists."
fi


sudo chown -R $FEATHER_USER:$FEATHER_GROUP $DEFAULT_DICT
sudo chmod -R 750 $DEFAULT_DICT






