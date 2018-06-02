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
REPO_DIR='/usr/local/etc/pkg/repo/offline/'
PACKAGES='pfSense-pkg-Backup pfSense-pkg-Cron pfSense-pkg-Notes pfSense-pkg-Open-VM-Tools pfSense-pkg-Shellcmd pfSense-pkg-Status_Traffic_Totals pfSense-pkg-bandwidthd pfSense-pkg-openvpn-client-export pfSense-pkg-tftpd'

#####################################################
#Script Variables
#
#####################################################
#Functions:
#
Download_packages ()
{
#Download all the packages into the new repository directory.
pkg upgrade
pkg update
mkdir -p "$REPO_DIR"
pkg fetch -y -d -o "$REPO_DIR" "$PACKAGES"
}
#
#===================================
#
Create_repo ()
{
mkdir "$REPO_DIR"
pkg repo "$REPO_DIR"
echo 'local_repo: {' > /usr/local/etc/pkg/repos/local_repo.conf
echo '  url: "file:///usr/local/etc/pkg/repos/offline",' >> /usr/local/etc/pkg/repos/local_repo.conf
echo '  mirror_type: "none",' >> /usr/local/etc/pkg/repos/local_repo.conf
echo '  enabled: yes' >> /usr/local/etc/pkg/repos/local_repo.conf
echo '}'
}
#===================================
#
Disable_default_repos ()
{
sed -i "s/enabled: yes/enabled: no/g" /usr/local/etc/pkg/repos/pfSense.conf
}
#
####################################################
#Run script:
#
Download_packages
Create_repo
Disable_default_repos

