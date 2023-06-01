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

apk add curl        # URL retrival utility and library
                    # https://curl.se/


apk add awake       # python command and library to 'wake on lan' a remote host
                    # https://github.com/cyraxjoe/awake
                    