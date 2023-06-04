#!/bin/sh

# /root/bin/reinstall-core-ish-apps-part2.sh

#  description : Reinstall core Alpine Linux apps on iSH.app iOS
#       author : Janusz Oles
#      version : 20230601-01
#        usage : sh reinstall-core-ish-apps-part2.sh
#         NOTE : 


####### AFTER RESTART ########################################################
## new script ###
##############################################################################
rc-update add sshd  # add sshd to services
echo "==> Default repo locations"
cat /etc/apk/repositories
echo "---"
# append new lines
echo "==> Change to Alpine Linux repositories"
echo https://dl-cdn.alpinelinux.org/alpine/v3.14/main >> /etc/apk/repositories
echo https://dl-cdn.alpinelinux.org/alpine/v3.14/community >> /etc/apk/repositories
# rem old lines
sed -i -e '/http:\/\/apk.ish.app/d' /etc/apk/repositories 


rc-update add sshd  # add sshd to services

apk add curl        # URL retrival utility and library
                    # https://curl.se/

apk add awake       # python command & library to 'wake on lan' a remote host
                    # https://github.com/cyraxjoe/awake
apk add \
  nvim \
  stow \
  tmux \
  tmux-doc \


		    
