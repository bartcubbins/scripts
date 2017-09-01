#!/bin/bash

red="\033[01;31m"
green="\033[01;32m"
blue="\033[01;34m"
white="\033[01;37m"
nc="\033[0m"
bold="\033[1m"

repos_array=([0]="platform_build" [1]="platform_external_toybox"
             [2]="platform_frameworks_av" [3]="platform_frameworks_base"
             [4]="platform_frameworks_native" [5]="platform_hardware_qcom_audio"
             [6]="platform_hardware_qcom_bt" [7]="platform_hardware_qcom_display"
             [8]="platform_hardware_qcom_gps" [9]="platform_hardware_qcom_keymaster"
             [10]="platform_hardware_qcom_media" [11]="platform_packages_apps_Nfc"
             [12]="platform_packages_apps_Settings" [13]="platform_packages_providers_DownloadProvider"
             [14]="platform_packages_providers_MediaProvider" [15]="platform_system_core")

clear
echo -e "${bold}${red}======================================================================"
echo -e "                            Branch removal"
echo -e "======================================================================${blue}"
echo
echo -e "Please enter the name of the branch to be deleted:"
echo
echo -e -n "Branch name: "
read branch_name

cd ../ # we have sources near scripts folder

for repo_name in "${repos_array[@]}"; do
    cd $repo_name
    git branch -d $branch_name
    git push origin --delete $branch_name
    echo
    echo -e "${green}======================================================================"
    echo -e "Branch: "$branch_name" was removed from "$repo_name" repository${nc}"
    echo -e "${green}======================================================================"
    cd ../
done

echo
echo -e "${white}======================================================================"
echo -e "                          All jobs are done!"
echo -e "======================================================================"
read -p "Go to the main menu? [Y/n]: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    clear
    bash ./scripts/menu # small hack:)
else
    exit 1
fi