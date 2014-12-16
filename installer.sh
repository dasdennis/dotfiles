#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"



# git
ln -s ${BASEDIR}/.git ~/
ln -s ${BASEDIR}/.gitconfig ~/
ln -s ${BASEDIR}/.gitignore ~/

# gemrc
ln -s ${BASEDIR}/.gemrc ~/

#web pullers
ln -s ${BASEDIR}/.curlrc ~/
ln -s ${BASEDIR}/.wgetrc ~/

#bashy
ln -s ${BASEDIR}/.aliases ~/
ln -s ${BASEDIR}/.bash_profile ~/
ln -s ${BASEDIR}/.bashrc ~/


#postgres
ln -s ${BASEDIR}/.psqlrc ~/

#hostfile
ln -s ${BASEDIR}/.host_file_update.sh ~/