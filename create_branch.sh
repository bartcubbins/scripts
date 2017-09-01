#!/bin/bash

source ./resources/reponame_array.sh

red="\033[01;31m"
green="\033[01;32m"
blue="\033[01;34m"
white="\033[01;37m"
nc="\033[0m"
bold="\033[1m"

clear
echo -e "${bold}${red}======================================================================"
echo -e "                            Branch creator"
echo -e "======================================================================${blue}"
echo
echo -e "Please enter the name for the new branch:"
echo
echo -e -n "New branch name: "
read branch_name

cd ../ # we have sources near scripts folder

for repo_name in "${repos_array[@]}"; do
    cd $repo_name
    git reset --hard
    git checkout -b $branch_name
    git push origin $branch_name
    echo
    echo -e "${green}======================================================================"
    echo -e "Branch: "$branch_name" was created in "$repo_name" repository${nc}"
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