# Minecraft server backup to remote host
Packaging is done on localhost in case the remote host is not powerful enough.

The script was made for my setup but you can change it however you want to suit your setup.
### Requirements:
* minecraft server running in a `screen`
* ssh keys set up between the hosts
* passwordless `at` on remote host (dumb but works)
* enabled wake-on-lan feature on remote motherboard
* `rsync`, `wakeonlan`, on remote `pm-utils`
