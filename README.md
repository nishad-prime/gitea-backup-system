# Gitea Backup System

A simple shell powered gitea backup system.

**Note**: This will only work if gitea is using `MySQL`, `mysqldump` command
is available, and if the system is using systemd for service management.

## Installation

1. Setup the Config

   Open the `config` file with a text editor and set all config as mentioned in
   the comments in the config file.

2. Run Install

   Run `install.sh` as root. Or if the current user is in the sudoers file, run:

   ```sh
   sudo ./install.sh
   ```

## Usage

The backup system has installed a service called `gitea-backup.service`.
Starting this service will create a backup. Start the service like this:

```sh
sudo systemctl start gitea-backup.service
```

**Note**: `sudo` won't prompt for password if `PERMIT_NONROOT_BACKUP` is set `yes`.
