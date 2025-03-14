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

WORKSPACE_TYPE=""
GIT_BRANCH=""
CWD=""

# Funcion: Detect type of workspace depending on build files
detect_workspace() {
    # Check for CMake-based projects.
    if [ -f "CMakeLists.txt" ]; then
        WORKSPACE_TYPE="  "
        return 0
    fi

    # Check for traditional Make projects.
    if [ -f "Makefile" ]; then
        WORKSPACE_TYPE="  "
        return 0
    fi

    # Check for Lua projects
    if [ -f "init.lua" ]; then
        WORKSPACE_TYPE="  "
        return 0
    fi

    # Check for Node.js projects.
    if [ -f "package.json" ]; then
        WORKSPACE_TYPE="  "
        return 0
    fi

    # Check for Maven projects.
    if [ -f "pom.xml" ]; then
        WORKSPACE_TYPE="  "
        return 0
    fi

    # Check for Gradle projects (either Groovy- or Kotlin-based).
    if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
        WORKSPACE_TYPE"  "
        return 0
    fi

    # Check for Python projects.
    if [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        WORKSPACE_TYPE"  "
        return 0
    fi

    # Check for Rust projects.
    if [ -f "Cargo.toml" ]; then
        WORKSPACE_TYPE" 󱘗 "
        return 0
    fi

    # Check for Go projects.
    if [ -f "go.mod" ]; then
        WORKSPACE_TYPE="  "
        return 0
    fi

    WORKSPACE_TYPE=""
    return 1
}

# Funcion: detect or update git_branch
update_git_branch() {
    # Check if the current directory is a Git repository
    if [ -d ".git" ]; then
        GIT_BRANCH="  $(git branch --show-current)"
    else
        GIT_BRANCH=""
    fi
}

# Function: update git status and add markers based on status
update_git_status(){

    if [ "$GIT_BRANCH" != "" ]; then
        if git status --porcelain| grep -q "^??"; then
            GIT_BRANCH="$GIT_BRANCH "
        fi 
        
        if git status --porcelain | grep -q "^[ M]"; then
            GIT_BRANCH="$GIT_BRANCH󱦺 "
        fi

        if git status --porcelain | grep -q "^A "; then
            GIT_BRANCH="$GIT_BRANCH "
        fi
    fi
}

#Function to trail long directory name
update_cwd(){
    # order of subsitution of icons for directories matters
    CWD="$(pwd | sed -e "s|$HOME/Books| |g" \
                     -e "s|$HOME/Downloads|󰉍 |g" \
                     -e "s|$HOME/Desktop| |g" \
                     -e "s|$HOME/Documents| |g" \
                     -e "s|$HOME/Pictures| |g" \
                     -e "s|$HOME/Music| |g" \
                     -e "s|$HOME/Videos| |g" \
                     -e "s|$HOME/.config| |g"\
                     -e "s|$HOME|󱂵 |g" \
    )"
   
   local columns="$(tput cols)"     # get screen width
   # Maximum cwd length to display at prompt must be 25% of total width in character
   local MAX_CWD_LENGTH="$(( 25 * ${columns} / 100 ))"
   
   if [[ ${#CWD} -gt ${MAX_CWD_LENGTH} ]]; then
        CWD="${CWD%/}" # remove trailing slash to ensure proper operation
        CWD="󰇘${CWD##*/}"  
   fi
}

#Function: It'll update all the information required by PS1
update_info() {
    detect_workspace
    update_git_branch
    update_git_status
    update_cwd
    echo # Just to add gaps between each prompts
}

PROMPT_COMMAND="update_info"

A=17      # username forground
B=226     # username background

C=22      # git forground
D=178     # git background

E=22      # cwd forground
F=226     # cwd background

G=226     # project_type forground
H=196     # project_type background

PS1="\
\[\e[1;38;5;${B};48;5;0m\]\
 \
\[\e[1;38;5;${A};48;5;${B}m\]\
 \u \
\[\e[0;38;5;${H};48;5;${B}m\]\
 \
\[\e[1;38;5;${G};48;5;${H}m\]\
\$WORKSPACE_TYPE\
\[\e[1;38;5;${H};48;5;${D}m\]\
 \
\[\e[1;38;5;${C};48;5;${D}m\]\
\$GIT_BRANCH\
\[\e[0;38;5;${D};48;5;${F}m\]\
 \
\[\e[1;38;5;${E};48;5;${F}m\]\
 \$CWD \
\[\e[0;38;5;${F};48;5;0m\]\
 \
\[\e[0m\]\
"

