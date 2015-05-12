#!/bin/bash

# Check we have a target directory
if [ -z $1 ]
then
    echo "Usage: cfsetup.sh [target installation directory]"
    exit 1
fi

# Welcome
echo -e "\n####### Welcome to the Cluster Flow v0.4devel Installer for UPPMAX users #######"
echo -e "### Step 1: Cloning github repositories..\n"

# Clone the repos
STARTDIR=$(pwd)
mkdir -p $1
cd $1
git clone --recursive https://github.com/ewels/clusterflow.git .
git clone https://github.com/ewels/clusterflow-uppmax.git scripts

# Copy the UPPMAX config file
cp ${STARTDIR}/clusterflow.config.uppmax ./clusterflow.config

# Add to PATH
echo -n -e "\n### Step 2 - can I add this installation directory to your .bashrc PATH? (y/n):\n"
read addbashrc
if [ ${addbashrc:0:1} == 'y' ]
then
    echo -e "\n\n## Added by Cluster Flow installer\nexport PATH="'$PATH'":$(pwd)\nexport PATH="'$PATH'":$(pwd)/scripts" >> ~/.bashrc
    echo -e "\n\nOk, done.\n\n"
else
    echo -e "\n\nOk.\n\n"
fi

# Launch Cluster Flow wizards
echo -e "### Step 3 - Launching the 'add reference genome' wizard..\n\n"
sleep 2
./scripts/cf-uppmax --add_genome

echo -e "\n\n### Step 4 - Launching the Cluster Flow config wizard..\n\n"
sleep 2
./cf --setup

echo -e "\n\n#######  Cluster Flow installation complete  #######\n\n"
echo -e "\n\n#######   Now please log out and in again.   #######\n\n"
