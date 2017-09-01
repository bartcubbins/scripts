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
    cd ./scripts
    bash ./menu # small hack:)
else
    exit 1
fi