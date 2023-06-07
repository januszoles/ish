#!/bin/ash

# /root/bin/reinstall-core-ish-apps-part1.sh

#  description : Reinstall and setup core Alpine Linux apps (iSH.app iOS)
#       author : Janusz Oles
#      version : 20230607-03
#        usage : sh /root/bin/reinstall-core-ish-apps-part1.sh
#         NOTE : need your interaction to set up root password
#                timezone is set to Europe/Warsaw
#                WORK IN PROGRESS!!!
######################################################################
##### EDIT! 
GIT_USER="yourname"
GIT_EMAIL="youremail@example.com"
GIT_DEFAULT_BRANCH="main"            #  master|main|whatever
GIT_CORE_EDITOR="nvim"               #! for now workos only with nvim
TIMEZONE="/Europe/Warsaw"            # change to your location
#
# Central European Summer Time (CEST) is 2 hours ahead of 
# Coordinated Universal Time (UTC).
#####################################################################

## DEFINE COLORS
bold='\033[1m'
black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
white='\033[0;37m'
reset='\033[0m'

_info(){
  printf "%b\n" "${blue}==> $1${reset}"
}

_error(){
  printf "%b\n" "${red}[!] $1${reset}"
}


_div(){
  printf "%s\n" "---"
}


_info "Default repo locations"
cat /etc/apk/repositories
_div
# append new lines
_info "Change to Alpine Linux repositories"
echo https://dl-cdn.alpinelinux.org/alpine/v3.14/main >> /etc/apk/repositories
echo https://dl-cdn.alpinelinux.org/alpine/v3.14/community >> /etc/apk/repositories
# rem old lines
sed -i -e '/http:\/\/apk.ish.app/d' /etc/apk/repositories 

# check
_info "New repo locations"
cat /etc/apk/repositories
_div


_info "Update and upgrade from new repo"
apk update
apk upgrade

_add_man() {
_info "Add man pages"
apk add man-pages
apk add mandoc-apropos
}


_add_nvim() {
  _info "Add nvim"
  apk add nvim
  apk add nvim-doc
}


_set_timezone() {
  _info "Add timezone data and set my timezone to ${TIMEZONE}"
  date
  apk add tzdata 
  # check if 'tzdata' is installed 
  APP_TZDATA=`which tzdata`
  if [ -z "${APP_TZDATA}" ];then  
    _error "Could not find the 'tzdata' executable"
      exit 1
  fi

  # check if timezone is set
  if [ -z "${TIMEZONE}" ];then  
    _error "No timezone set"
      exit 1
  fi


  cp /usr/share/zoneinfo/"${TIMEZONE}" /etc/localtime
  date
  apk del tzdata
  _div
}

_add_git() {
  _info "Add version control system"
  apk add git         # version control system  
  apk add git-doc     # git man pages
}

_set_git() {
  _info "Set up git"

  # check if 'git' is installed 
  APP_GIT=`which git`

  if [ -z "${APP_GIT}" ];then  
    _error "Could not find the 'git' executable"
      exit 1
  fi

  # check if 'nvim' is installed 
  APP_NVIM=`which nvim`

  if [ -z "${APP_NVIM}" ];then  
    _error "Could not find the 'nvim' executable"
      exit 1
  fi

  git config --global user.name "$GIT_USER"
  git config --global user.email "$GIT_EMAIL"
  git config --global init.defaultBranch "$GIT_DEFAULT_BRANCH" 
  
  git config --global color.ui auto
  
  # Global ignore file:
  echo ".DS_Store" >> ~/.gitignore
  git config --global core.excludesfile ~/.gitignore
  
  git config --global core.editor "$GIT_CORE_EDITOR"
  
  git config --global diff.tool nvimdiff
  git config --global merge.tool nvimdiff
  git config --global --add difftool.prompt false
  git config --global alias.dt difftool
  git config --global difftool.nvimdiff.cmd '/usr/bin/nvim -d "$LOCAL" "$REMOTE"'
  _info "List git configuration:"
  git config --list
  _div
  cat ~/.gitconfig
  _div
}

_add_openssh() {
  _info "Add and set-up SSH server (https://www.openssh.com/portable.html)"
  apk add openssh     # ssh server
}


_add_openrc() {
  _info "Add OpenRC to manage sshd start" 
  apk add openrc     
}

_edit_inittab() {
  _info "Edit /etc/inittab"
  _info "::sysinit:/sbin/openrc sysinit --> ::sysinit:/sbin/openrc"
  _div
  cat -n /etc/inittab |head -n3

  # Define the line to search for and the replacement
  local s="::sysinit:/sbin/openrc sysinit"
  local r="::sysinit:/sbin/openrc"
  
  # Use sed to replace the first instance of the line in the file
  sed -i -e ":a" -e  "\$!{N;ba" -e "}; s|$s|$r|" /etc/inittab
  _div
  cat -n /etc/inittab |head -n3
  _info "Comment out the tty's, there is no access to them, waist of memory."
  _div
  cat -n /etc/inittab |awk 'NR >= 9 && NR <= 14'
  sed -i -r 's/^(tty[[:digit:]])/# \1/' /etc/inittab
  _div
  cat -n /etc/inittab |awk 'NR >= 9 && NR <= 14'
  _div

}

_set_ssh() {
  _info "Set-up SSH server (https://www.openssh.com/portable.html)"
  
  _info "Set the password for root login"
  passwd
  
  _info "Append line 'PermitRootLogin yes' to the end of sshd_config"
  # so you can ssh to this device.
  cat -n /etc/ssh/sshd_config |tail -2
  _div
  echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
  cat -n /etc/ssh/sshd_config |tail -2
 _div
}
# cat /etc/inittab
_add_man
_add_nvim
_add_git
_add_openssh
_add_openrc

_set_timezone
_set_git
_set_ssh
_edit_inittab
_info "Need to restart ish before adding sshd to OpenRC"
exit
##### END OF SSH SET-UP ######################################################
##### END OF reinstall-core-ish-apps-part1.sh ################################
##############################################################################
