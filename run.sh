#!/bin/sh
# ------------------------------Check If Installed------------------------------
if [ -f "./install.sh" ]; then
    echo "Please run install.sh to install it first."
    exit 1
fi
# ------------------------------Retriving Configs-------------------------------
conf="$(sed '/^\s*#/d; /^\s*$/d' config)"

backupid="$(date +%Y%m%d%H%M%S)"
backupdir="$(echo "$conf" | grep BACKUP_DIR | sed 's/^[^=]*=//')"
backupname=gitea"$backupid".tar.gz
giteahomedir="$(echo "$conf" | grep GITEA_HOME_DIR | sed 's/^[^=]*=//')"

dbname="$(echo "$conf" | grep DB_NAME | sed 's/^[^=]*=//')"
dbuser="$(echo "$conf" | grep DB_USER | sed 's/^[^=]*=//')"
dbpass="$(echo "$conf" | grep DB_PASS | sed 's/^[^=]*=//')"
# --------------------------------Running Backup--------------------------------
mkdir -p "$backupid"
cd "$backupid" || exit

echo Running Gitea Dump
/usr/local/bin/gitea dump -c "$giteahomedir"/app.ini
echo Running MySQL Dump
mysqldump --no-tablespaces -u"$dbuser" -p"$dbpass" "$dbname" > gitea-db.sql

cd ..

echo Creating Zip Archive
tar czf "$backupname" "$backupid"
echo Removing the Dangling Backup Folder
rm -rf "$backupid"
echo Removing Old Backups
rm "$backupdir"/gitea*
echo Moving Backup to Backup Directory
mkdir -p "$backupdir"
mv "$backupname" "$backupdir"
echo Done
