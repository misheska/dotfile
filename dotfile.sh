#!/usr/bin/env bash

# dotfile.sh

set -o nounset # -u
set -o errexit # -e

# Define some colors
textdefault="\e[0m"
textred="\e[1;31m" # Red - error
textgreen="\e[1;32m" # Green - success
textblue="\e[1;34m" # Blue - no action/ignored

function run {
    local command=$1
    echo "[Running] $command"
    if [[ $DRY_RUN != true ]]; then
        $($command)
    fi
}

function symlink {
    # Mac OS X BSD readlink does not support -f
    # Use this more portable equivalent
    local dotfile_dir=$( cd $(dirname $1) ; pwd -P)/$1
    for filepath in `find $dotfile_dir -mindepth 1 -maxdepth 1`; do
        file=`basename $filepath`
        source="$dotfile_dir/$file"
        target="$HOME/.$file"
        if [[ -e $HOME/$file && $(readlink "$target") == "$source" ]]; then
            continue
        fi

        echo "======================$file======================"
        echo "Source: $source"
        echo "Target: $target"

        if [ -e $target ]; then
            echo "[Overwriting] $target..."
            echo "leaving original at $target.orig...."
            run "mv $target $target.orig"
        fi

        run "ln -nfs $source $target"

        echo "================================================"
    done
}

DRY_RUN=false

# BSD getopt that comes with Mac OS X does not support long arguments
while getopts ":d" opt; do
    case $opt in
        d)
            DRY_RUN=true
            echo "dry-run mode..." >&2
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;; 
    esac
done

symlink vim

printf "$textgreen%s$textdefault\n" "SUCCESS: Dotfiles linked"
