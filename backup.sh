#!/bin/sh
minecraft_screen="mc"
minecraft_dir="mc/"
temp_dir="bkp_tmp"
remote_mac_addr="00:00:00:00:00:00"
remote_user="dj0rdj3"
remote_ip="192.168.0.10"
remote_dir="/mnt/backup/mc"
dte=`date +"%H-%M_%d-%m-%Y"`
backup_name="${minecraft_screen}_${dte}"

printf "Starting backup\n"
screen -p 0 -S $minecraft_screen -X eval 'stuff "save-off"\015' >> /dev/null
screen -p 0 -S $minecraft_screen -X eval 'stuff "save-all"\015' >> /dev/null
mkdir $temp_dir
printf "Copying files..."
rsync -aq $minecraft_dir $temp_dir --exclude plugins/dynmap/web/tiles/
printf " done\n"
screen -p 0 -S $minecraft_screen -X eval 'stuff "save-on"\015' >> /dev/null
printf "Waking up remote storage\n"
wakeonlan $remote_mac_addr >> /dev/null
printf "Zipping files..."
cd $temp_dir/
zip -r -q ../$backup_name.zip *
cd ..
printf " done\n"
printf "Transferring files to remote storage..."
rsync -aq $backup_name.zip $remote_user@$remote_ip:$remote_dir
printf " done\n"
printf "Cleaning up..."
rm -rf $temp_dir
rm -rf $backup_name.zip
ssh $remote_user@$remote_ip "find /mnt/backup/mc -maxdepth 1 -mtime +4 -delete" >> /dev/null
#in the line above, the find command doesnt work for some reason if i put in the minecraft dir var
printf " done\n"
printf "Putting remote storage to sleep\n"
screen -m -d ssh $remote_user@$remote_ip "echo 'pm-suspend' | sudo at now + 1min" >> /dev/null
printf "Backup done\n"
