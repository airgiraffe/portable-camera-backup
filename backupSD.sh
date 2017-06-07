#!/bin/bash
function confirm {
while true; do
    read -p "Continue with only one backup device? " yn
    case $yn in
        [Yy]* ) echo "Backing up..."; break;;
        [Nn]* ) echo "!----ABORTING----!"; exit;;
        * ) echo "INVALID: use Y/y or N/n.";;
    esac
done
}

#Check for SD

if ! grep -q /media/card\  /proc/mounts
then
    echo "!----ERROR: NO SD CARD----!"
    exit 0
else
    echo "SD OKAY..."
fi

#Check for Backup Devices

if (( grep -q /media/backup\  /proc/mounts ) && ( grep -q /media/backup2\  /proc/mounts ))
then
    echo "Both Backups mounted"
    rsync -avh --ignore-existing /media/card/ /media/backup
    echo "BACKUP 1 COMPLETE"
    rsync -avh --ignore-existing /media/card/ /media/backup2
    echo "BACKUP 2 COMPLETE"
elif grep -q /media/backup\  /proc/mounts
    then
    echo "CAUTION: Backup_2 missing, Backup_1 OKAY"
    confirm
    rsync -avh --ignore-existing /media/card/ /media/backup

elif grep -q /media/backup2\  /proc/mounts
    then
    echo "CAUTION: Backup_1 missing, Backup_2 OKAY"
    confirm
    rsync -avh --ignore-existing /media/card/ /media/backup2

else
    echo "ERROR: NO BACKUP DEVICES"
    exit 0
fi
