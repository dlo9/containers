#!/bin/sh

# https://stackoverflow.com/questions/5412761/using-colors-with-printf
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
lime_yellow=$(tput setaf 190)
powder_blue=$(tput setaf 153)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
bright=$(tput bold)
normal=$(tput sgr0)
blink=$(tput blink)
reverse=$(tput smso)
underline=$(tput smul)

println_colored() {
	color="$1"
	shift

	printf "%s%s%s\n" "$color" "$@" "$normal"
}

info() {
	println_colored "$blue" "$@"
}

for folder in *; do
	dockerfile="$folder/Dockerfile"
	if [ -f "$dockerfile" ]; then
		image_tag="dlo9/$folder"
		context="$folder"

		info "Building $folder..."
		docker build -t "$image_tag" -f "$dockerfile" "$context" 
	fi
done
