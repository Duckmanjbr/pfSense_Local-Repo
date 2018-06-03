#!/bin/sh
#
#Info
#=======================
#	File: pfSense_local-repo.sh
#	Name: Create local repositories on pfSense
#
	VERSION_NUM='1.0'
# 	*Version is major.minor format
# 	*Major is updated when new capability is added
# 	*Minor is updated on fixes and improvements
#
#History
#=======================		
#	 2Jun2018 v1.0 
#		Dread Pirate
#		*Initial build
#		*Creates/Enables local repo and disables pfSense repos.
#	
#
#Description 
#=======================
# This script creates a local repository on pfSense and pulls down the added packages into the new repo.
# This script will also disable all remote repositories and stop pfSense from calling out to pkg.pfSense.org for pkg updates.
#
#Notes
#=======================
#https://github.com/Duckmanjbr/pfSense_Local-Repo
#
#####################################################
#Selectable Variables (user selected)
#
REPO='local_repo'
REPO_CONF='local_repo.conf'
PACKAGES=""
PACKAGES="${PACKAGES} pfSense-pkg-Backup"
PACKAGES="${PACKAGES} pfSense-pkg-Cron"
PACKAGES="${PACKAGES} pfSense-pkg-Notes"
PACKAGES="${PACKAGES} pfSense-pkg-Open-VM-Tools"
PACKAGES="${PACKAGES} pfSense-pkg-Shellcmd"
PACKAGES="${PACKAGES} pfSense-pkg-Status_Traffic_Totals"
PACKAGES="${PACKAGES} pfSense-pkg-bandwidthd"
PACKAGES="${PACKAGES} pfSense-pkg-openvpn-client-export"
PACKAGES="${PACKAGES} pfSense-pkg-tftpd"
PACKAGES="${PACKAGES} pfSense-pkg-sudo"
#PACKAGES="${PACKAGES} pfSense-pkg*"
#
#####################################################
#Script Variables
#
REPO_DIR='/usr/local/etc/pkg/repos'
#
#####################################################
#Functions:
#
Header ()		
{		
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"		
}		
#
#==================================
#
Download_packages ()
{
#Download all the packages into the new repository directory.
Header
echo "++++++++++++++++ Updating packages  +++++++++++++++++"
pkg update
pkg upgrade
#pkg search "pfSense-pkg*" | awk '{ print $1 }'
mkdir -p "$REPO_DIR"/"$REPO"
for PACKAGE in $PACKAGES; do
        echo "+++++++++++ Downloading $PACKAGE +++++++++++"
        pkg fetch -y -d -o "$REPO_DIR"/"$REPO" $PACKAGE
done
}
#
#===================================
#
Create_repo ()
{
Header
echo "++++++++++++++++   Creating repo   ++++++++++++++++++"
echo ""
pkg repo "$REPO_DIR"/"$REPO"
Header
echo "++++++++++   Creating $REPO_CONF  ++++++++++++++"
echo ""
echo 'local_repo: {' > "$REPO_DIR"/"$REPO_CONF"
echo "  url: file://$REPO_DIR/$REPO," >> "$REPO_DIR"/"$REPO_CONF"
echo '  mirror_type: "none",' >> "$REPO_DIR"/"$REPO_CONF"
echo '  enabled: yes,' >> "$REPO_DIR"/"$REPO_CONF"
echo '}' >> "$REPO_DIR"/"$REPO_CONF"
chmod 755 "$REPO_DIR"/"$REPO_CONF"
pkg update
}
#===================================
#
Disable_default_repos ()
{
Header
echo "+++++++++++++++  Disabling pfSense repos  ++++++++++"
echo ""
sed -i -e 's/enabled: yes/enabled: no/g' /usr/local/share/pfSense/pkg/repos/pfSense-repo.conf
}
# 
#===================================
#
Clean_up ()
{
Header
echo "++++++++++  Cleaning up remnants of script +++++++++"
echo ""
rm -fR "$REPO_DIR"/"$REPO_CONF" "$REPO_DIR"/"$REPO"
sed -i -e 's/enabled: no/enabled: yes/g' /usr/local/share/pfSense/pkg/repos/pfSense-repo.conf
}
#
####################################################
#Run script:
#
Download_packages
Create_repo
Disable_default_repos
#Clean_up
