#!/bin/bash

set -o errexit # -e bail on error
set -o nounset # -u bail if uninitialized variable used
set -o xtrace # -x print trace of commands
set -o verbose # -v print lines as they are read

# Ask for the administrator password upfront
sudo -v

# Create subl lauch script for Sublime Text 2
subl_app=/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl
if [ ! -f "/usr/local/bin/subl" ] && [ -f "$subl_app" ]
then
    # On a Mac, /usr/bin, /bin & /usr/local/bin are in $PATH by default
    # Use /usr/local/bin, but oddly enough it doesn't exist on a clean Mac
    # setup
    sudo mkdir -p /usr/local/bin
    echo "Creating subl launch script for Sublime 2"
    sudo ln -s "$subl_app" /usr/local/bin/subl
fi
