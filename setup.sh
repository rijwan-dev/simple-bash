#!/bin/bash

#################################################################################
# MIT License
#
# Copyright (c) 2025 Rijwan rijwan.25072004@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# See the LICENSE file for more details.
#################################################################################

## This is an automated installer of simple-bash
## This file don't need to modify even after adding new theme files in themes directory
## This script will automatically detect the theme files  from themes sub-directory


# Get the directory of the installer
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Enable nullglob so that if no files match, the array 
# will be empty instead of containing a literal pattern.
shopt -s nullglob

# store all *.bashrc files in the themes directory into an array.
THEMES=("${SCRIPT_DIR}/themes/"*.bashrc)

# This will be used to identify whether themes are installed using this script or not
MARKER="#\$\$\$SIMPLE-BASH-INSTALLER\$\$\$: If you remove this line manually, also remove the associated file!"

# Function to find a pattern in line/s a file and return relative file name on that line
get_identity_line() {
    local file="$1"        # file to look at
    local marker="$2"      # pattern to look for
    local result=""
    result=$(grep -F "$marker" "$file")   # line containing the pattern
    
    # extract and return file name from the line containing the unique pattern/marker
    # e.g, .arrow.bashrc in case of : 
    #`source ~/.arrow.bashrc $$$SIMPLE-BASH-INSTALLER$$$: If you remove this line manually, also remove the associated file!`
    echo "$result" | sed -n 's/^source[[:space:]]\+~\/\([^[:space:]]\+\).*$/\1/p'
}

# Function to remove previous installation
uninstall_previous() {
    local file="$1"        # file where installation is registered i.e, ~/.bashrc
    local marker="$2"      # marker from which installation distinguished i.e, $MARKER 
    local themefile="$HOME/$3"  # installed theme file home directory
    
    # Note: On mac-OS, sed need to supply an extra empty string argument to -i, like:
    # `sed -i '' "/$escaped_marker/d" "$file"`
    # remove the previous registered installation line (containing marker pattern) from the ~/.bashrc file
    sed -i "/$marker/d" "$file"
    # check for error
    if [[ $? -eq 0 ]]; then
        echo "\e[1;38;5;1m Successfully removed previous installation entry from $file e[0m"
    else
        echo -e "\e[1;38;5;1m Error: Couldn't remove previous installation entry!\e[0m"
        echo -e "\e[1;38;5;1m Try manually deleting line containing $marker from $file \e[0m"
    fi
   
    # remove the previous theme file
    rm "$themefile"
    #verify if successfully deleted previous theme file
    if [[ $? -eq 0 ]]; then
        echo "\e[1;38;5;1m Successfully removed previous theme file: $themefile e[0m"
    else
        echo -e "\e[1;38;5;1m Error: couldn't remove $themefile, try removing mannually. \e[0m"
    fi
    source $HOME/.bashrc # Update bash
}

# Function to filter out formating like `\[` and `\]`
filter_formating(){
  local input="$1"
  local output="${input//\\[/}"
  output="${output//\\]/}"
  echo "$output"
}

# Function to extract filename from absolute path
get_filename() {
  local path="$1"   # get absolute path
  path="${path%/}"  # remove trailing slash `/`
  # remove everything up to the last '/'
  echo "${path##*/}"
}

show_available_prompt_style(){
    echo -e "\n\t\t \e[4;38;5;3m Choose the theme you want to install:\n\n\e[0m"

    index=1
    #iterate over all files in THEMES
    for file in "${THEMES[@]}"; do
        echo "${index}: $(get_filename "$file")"    # print theme name and it's correspoinding index
        source "$file"      # load the theme file so that PS1 of that configuration will be visible here
        # preview the PS1 to see how prompt looks like
        if [[ $PS1 != "" ]]; then
            echo -e "$(filter_formating "$PS1")<command will go here>\n"
        else
            echo "[CAN'T PREVIEW PROMPT]"
        fi
        index=$(($index + 1))     # shift the index
    done
}

# Function to ask which theme to install
prompt_input(){
    local index=1  # reset the index

    read -p "Enter theme index you want to install (1-${#THEMES[@]}): " index
    validate_input $index
}

# Function to install the theme file based on index rank from THEMES array
install_theme(){
    
    local index="$(($1 - 1))"    # index into unix format
    local themefile="${THEMES[index]}"       # absolute path of theme file to be installed
    local filename="$(get_filename "$themefile")"  # name of the theme file

    echo "Installing theme: $filename"
    # target where theme file is installed.
    # add `.` to hide the themefile by default
    local target_to_install="$HOME/.$filename"

    # copy the file to user\'s home directory
    cp "${themefile}" "$target_to_install"
    # verify the if copied
    if [[ $? -eq 0 ]]; then
        echo -e "\e[1;38;5;11m Theme successfully installed: $target_to_install \e[0m"
        echo -e "\e[1;38;5;11m Feel free to modify the installed file. \e[0m"
    else
        echo -e "\e[1;38;5;1m Error: couldn't install the theme, quitting now... \e[0m"
        exit
    fi
    # update/register theme file in the `~.bashrc` file
    echo "source ~/.${filename} ${MARKER}" >> ${HOME}/.bashrc
    # check if `~.bashrc` file is updated or not
    if [[ "$(get_identity_line "${HOME}/.bashrc" "$MARKER")" != "" ]]; then
        echo "${HOME}/.bashrc file updated successfully!"
        echo "Sucessfully installed: $filename"
        echo "Run this script again if you want to reinstall, uninstall, or install different configuration"
        source $HOME/.bashrc # Update bash
    else
        echo -e "\e[1;38;5;1m Error: couldn't update ${HOME}/.bashrc file\e[0m"
        echo -e "\e[1;38;5;1m try adding `source ~/.${filename}` in ${HOME}/.bashrc file \e[0m"
    fi
    exit
}

# Function to validate user input
validate_input(){

    local index="$1"    # take index
    if [[ $index =~ ^[0-9]+$ ]]; then
        if (( $index > ${#THEMES[@]} || $index < 1 )); then
            echo -e "\e[1;38;5;1m Error: input is out of range.\e[0m"
            echo -e "\e[1;38;5;1m Please choose from 1 to ${#THEMES[@]}, i.e, total number of available themes.\e[0m"
            prompt_input
        else
            install_theme "$index"
        fi
    else
        if [[ "$index" == "q" ]]; then
            echo "Quiting..."
            exit
        else
            echo -e "\e[1;38;5;1m Error: Invalid input, Please enter number from 1 to ${#THEMES[@]}.\e[0m"
            echo -e "\e[1;38;5;1m If you want to abort enter \`q\` or Ctrl+C.\e[0m"
            prompt_input
        fi
    fi
}

# Function to check if there already have any previous installation
check_installed(){
    local themefile="$(get_identity_line "$HOME/.bashrc" "$MARKER")"
    if [[ "$themefile" == "" ]]; then
        # No previous installation
        return 0;
    else
        echo "$0 have detected already installed theme file: $themefile"
        local input=""
        read -p "Enter x to unistall, i to reinstall and other key to abort(x/i/?): " input
        if [[ $input == "x" ]]; then
            uninstall_previous "$HOME/.bashrc" "$MARKER" "$themefile"
            exit
        elif [[ $input == "i" ]]; then
            uninstall_previous "$HOME/.bashrc" "$MARKER" "$themefile"
            return 0;
        else
            exit
        fi
    fi
}

#check for previous installation
check_installed
# show all available prompt theme of theme files in theme sub-directory
show_available_prompt_style
# ask user which theme to install
prompt_input

