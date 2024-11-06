#!/bin/sh

# ---------------------------------Run as Root----------------------------------
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi
# ------------------------------Retriving Configs-------------------------------
conf="$(sed '/^\s*#/d; /^\s*$/d' config)"
giteauser="$(echo "$conf" | grep GITEA_USER | sed 's/^[^=]*=//')"
giteagroup="$(echo "$conf" | grep GITEA_GROUP | sed 's/^[^=]*=//')"
giteahomedir="$(echo "$conf" | grep GITEA_HOME_DIR | sed 's/^[^=]*=//')"
permitnonroot="$(echo "$conf" | grep PERMIT_NONROOT_BACKUP | sed 's/^[^=]*=//')"
# ------------------------------Start Installation------------------------------
echo Creating Installation Directory
mkdir -p "$giteahomedir"/backup

echo Copying Files Over
cp config run.sh "$giteahomedir"/backup
cp gitea-backup.service /etc/systemd/system

echo Changing Ownership
chown -R "$giteauser":"$giteagroup" "$giteahomedir"/backup

echo Reloading Systemd Daemons
systemctl daemon-reload

if [ "$(echo "$permitnonroot" | tr '[:upper:]' '[:lower:]')" = "yes" ]; then
  echo Allowing All Users to Run Gitea Backups
  cp systemd /etc/sudoers.d
fi

echo Installed Successfully!
