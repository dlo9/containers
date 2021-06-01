#!/bin/sh

############################
##### GLOBAL VARIABLES #####
############################

repo="dlo9"

#############################
##### UTILITY FUNCTIONS #####
#############################

# https://stackoverflow.com/questions/5412761/using-colors-with-printf
black=$(tput setaf 0 2>/dev/null)
red=$(tput setaf 1 2>/dev/null)
green=$(tput setaf 2 2>/dev/null)
yellow=$(tput setaf 3 2>/dev/null)
lime_yellow=$(tput setaf 190 2>/dev/null)
powder_blue=$(tput setaf 153 2>/dev/null)
blue=$(tput setaf 4 2>/dev/null)
magenta=$(tput setaf 5 2>/dev/null)
cyan=$(tput setaf 6 2>/dev/null)
white=$(tput setaf 7 2>/dev/null)
bright=$(tput bold 2>/dev/null)
normal=$(tput sgr0 2>/dev/null)
blink=$(tput blink 2>/dev/null)
reverse=$(tput smso 2>/dev/null)
underline=$(tput smul 2>/dev/null)

println_colored() {
    color="$1"
    shift

    printf "%s%s%s\n" "$color" "$@" "$normal"
}

info() {
    println_colored "$blue" "$@"
}

error() {
    println_colored "$red" "$@"
}

build_folder() {
    folder="$1"
    test -d "$folder"

    dockerfile="$folder/Dockerfile"
    if [ -f "$dockerfile" ]; then
        info "Building $folder..."
		cd "$folder"

        if [ -n "$push" ]; then
			args="$args --push"
		fi

        if [ -z "$multi_arch" ]; then
			args="$args --set '*.platform='"
		fi

		 eval docker buildx bake $args

		cd -
    fi
}

###########################
##### OPTIONS PARSING #####
###########################

usage() {
    cat << EOF
Usage: build.sh [OPTION]... [IMAGE]...
Builds docker images in the repository

    -m, --multi-arch    Build for every architecture
                        If not specified, only images for the host architecture will be built
    -p, --push          Push images to a repository. Only relevant with --multi-arch
    -r, --registry      Registry to push to
    -h, --help          Display this help
EOF
}


# Parse options
options=$(getopt -o mph --long multi-arch,push,help -- "$@")

if [ $? -ne 0 ]; then
    usage
    exit 1
fi

# Exit on error
set -e

eval set -- "$options"
while true; do
    case "$1" in
    -m|--multi-arch)
        multi_arch=1
        ;;
    -p|--push)
        push=1
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    --)
        shift
        break
        ;;
    esac

    shift
done

################
##### MAIN #####
################

if [ -z "$@" ]; then
    # Build for every folder
    set -- $(find . -maxdepth 1 -mindepth 1 -type d -not -name ".*" -printf '%f ')
fi

for folder in "$@"; do
    build_folder "$folder"
done
