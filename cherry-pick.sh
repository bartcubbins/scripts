#!/bin/bash

source ./resources/reponame_array.sh

red="\033[01;31m"
green="\033[01;32m"
blue="\033[01;34m"
white="\033[01;37m"
nc="\033[0m"
bold="\033[1m"

clear
echo -e "${red}======================================================================"
echo -e "       ${red}Please select what the repositories you want to update:"
echo -e "======================================================================${blue}"
echo
echo -e "> MAIN MENU"
echo
echo -e "[1] Android 8.0.0_r4"
echo -e "[2] Android 7.1.2_r27"
echo
echo -e "[0] Back to menu"
echo
echo -e -n "Enter option: "
read -n1 opt
echo
echo

case $opt in
    1)
        bash ./resources/cherry-pick_O.sh
        ;;
    0)
        bash ./menu
        ;;
esac