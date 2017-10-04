#!/bin/bash

source ./resources/reponame_array.sh

red="\033[01;31m"
green="\033[01;32m"
blue="\033[01;34m"
white="\033[01;37m"
nc="\033[0m"
bold="\033[1m"

function_update()
{
    cd $repo_name
    git reset --hard
    git remote add google https://android.googlesource.com/${repo_name//_//}
    git remote update
    git checkout tags/$google_revision
    git push origin HEAD:$our_branch -f
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
echo -e "[1] Android 8.0.0_r17"
echo -e "[2] Android 7.1.2_r33"
echo
echo -e -n "Enter option: "
read -n1 opt
echo
echo

cd ../ # we want to pull sources near scripts folder

case $opt in
    1)
        google_revision="android-8.0.0_r17"
        our_branch="android-8.0"
        echo -e "${green}======================================================================"
        echo -e "             Android 8.0.0_r17 was selected"
        echo -e "======================================================================"
        sleep 3
        for repo_name in "${repos_array[@]}"; do
            function_clone
        done
        ;;
    2)
        google_revision="android-7.1.2_r33"
        our_branch="android-7.1"
        echo -e "${green}======================================================================"
        echo -e "                   Android 7.1.2_r33 was selected"
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
