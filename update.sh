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

function_update()
{
    cd $repo_name
    git reset --hard
    git remote add google https://android.googlesource.com/${repo_name//_//}
    git remote update
    git push origin google/$google_revision:$our_branch -f
    echo
    echo -e "${bold}${green}======================================================================"
    echo -e "Repo: ${PWD##*/} sync complete${nc}"
    echo -e "${green}======================================================================"
    echo
    cd ../
}

function_clone()
{
    if [ ! -d "$repo_name" ]; then
        echo -e "${red}======================================================================"
        echo -e "${red}Let's start downloading and syncing "$repo_name" repo"
        echo -e "${red}======================================================================${blue}"
        echo
        git clone git@github.com:SonyM4/$repo_name.git
        function_update
    else
        echo -e "${red}======================================================================"
        echo -e "${red}Let's start syncing "$repo_name" repo"
        echo -e "${red}======================================================================${blue}"
        echo
        function_update
    fi
}

clear
echo -e "${red}======================================================================"
echo -e "       ${red}Please select what the repositories you want to update:"
echo -e "======================================================================${blue}"
echo
echo -e "> MAIN MENU"
echo
echo -e "[1] Android O master branch"
echo -e "[2] Android 7.1.2_r27"
echo
echo -e -n "Enter option: "
read -n1 opt
echo
echo

cd ../ # we want to pull sources near scripts folder

case $opt in
    1)
        google_revision="master"
        our_branch="android-8.0-preview"
        echo -e "${green}======================================================================"
        echo -e "             Android O Developer Preview 3 was selected"
        echo -e "======================================================================"
        sleep 3
        for repo_name in "${repos_array[@]}"; do
            function_clone
        done
        ;;
    2)
        google_revision="android-7.1.2_r27"
        our_branch="android-7.1"
        echo -e "${green}======================================================================"
        echo -e "                   Android 7.1.2_r27 was selected"
        echo -e "======================================================================"
        sleep 3
        for repo_name in "${repos_array[@]}"; do
            function_clone
        done
        ;;
esac

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