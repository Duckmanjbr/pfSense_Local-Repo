#!/bin/sh
#
#Info
#=======================
#	File: pfSense_local-repo.sh
#	Name: Create local repositories on FreeBSD (pfSense)
#
	VERSION_NUM='1.0'
# 	*Version is major.minor format
# 	*Major is updated when new capability is added
# 	*Minor is updated on fixes and improvements
#
#History
#=======================		
#	13Dec2017 v1.0 
#		Dread Pirate
#		*Initial build to create local repo and pull a list of packages.
#	
#
#Description 
#=======================
# This script creates a local repository on FreeBSD and pulls down the added packages into the new repo.
# This script will also disable all remote repositories and stop pfSense from calling out to pfSense.org.
#
#Notes
#=======================
# https://github.com/Duckmanjbr/DIP_Config/blob/master/pfSense_local-repo.sh
#
#####################################################
#Selectable Variables (user selected)
#
REPO='offline'
REPO_CONF='local_repo.conf'
PACKAGES='pfSense-pkg-Backup pfSense-pkg-Cron pfSense-pkg-Notes pfSense-pkg-Open-VM-Tools pfSense-pkg-Shellcmd pfSense-pkg-Status_Traffic_Totals pfSense-pkg-bandwidthd pfSense-pkg-openvpn-client-export pfSense-pkg-tftpd'

#####################################################
#Script Variables
#
REPO_DIR='/usr/local/etc/pkg/repos'
#####################################################
#Functions:
#
Download_packages ()
{
#Download all the packages into the new repository directory.
pkg upgrade
pkg update
mkdir -p "$REPO_DIR"/"$REPO"
pkg fetch -y -d -o "$REPO_DIR"/"$REPO" "$PACKAGES"
}
#
#===================================
#
Create_repo ()
{
pkg repo "$REPO_DIR"/"$REPO_CONF"
echo 'local_repo: {' > "$REPO_DIR"/"$REPO_CONF"
echo "  url: file://$REPO_DIR/$REPO," >> "$REPO_DIR"/"$REPO_CONF"
echo '  mirror_type: "none",' >> "$REPO_DIR"/"$REPO_CONF"
echo '  enabled: yes,' >> "$REPO_DIR"/"$REPO_CONF"
echo '}' >> "$REPO_DIR"/"$REPO_CONF"
}
#===================================
#
Disable_default_repos ()
{
sed -i "s/enabled: yes/enabled: no/g" "$REPO_DIR"/pfSense.conf
}
#
####################################################
#Run script:
#
Download_packages
Create_repo
Disable_default_repos

