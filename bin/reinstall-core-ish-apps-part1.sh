#!/bin/sh

# /root/bin/reinstall-core-ish-apps.sh

#  description : Reinstall core Alpine Linux apps on iSH.app iOS
#       author : Janusz Oles
#      version : 20230601-01
#        usage : sh reinstall-core-ish-apps.sh
#         NOTE : need your interaction to set up root password

echo "==> Default repo locations"
cat /etc/apk/repositories
echo "---"
# append new lines
echo "==> Change to Alpine Linux repositories"
echo https://dl-cdn.alpinelinux.org/alpine/v3.14/main >> /etc/apk/repositories
echo https://dl-cdn.alpinelinux.org/alpine/v3.14/community >> /etc/apk/repositories
# rem old lines
sed -i -e '/http:\/\/apk.ish.app/d' /etc/apk/repositories 

# check
echo "==> New repo locations"
cat /etc/apk/repositories
echo "---"

echo "==> Update and upgrade"
apk update
apk upgrade

echo "==> Add man pages"
apk add man-pages
apk add mandoc-apropos

echo "==> Add version control system (https://www.git-scm.com/)"
apk add git         # version control system  
apk add git-doc     # git man pages

echo "==> Add and set-up SSH server (https://www.openssh.com/portable.html)"
apk add openssh     # ssh server


echo "==> SET the password for root login"
passwd

echo "==> Append line 'PermitRootLogin yes' to the end of sshd_config"
# so I can can ssh to this device.
cat -n /etc/ssh/sshd_config |tail -2
echo "---"
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
cat -n /etc/ssh/sshd_config |tail -2
echo "---"

echo "==> Add OpenRC to manages sshd start (https://github.com/OpenRC/openrc)"
apk add openrc      # manages the services, startup and shutdown of a host

echo "==> Edit 3rd line of inittab"
echo "::sysinit:/sbin/openrc sysinit --> ::sysinit:/sbin/openrc"
echo "---"
cat -n /etc/inittab |head -n3
sed -i 's|::sysinit:/sbin/openrc sysinit|::sysinit:/sbin/openrc|' /etc/inittab
echo "---"
cat -n /etc/inittab |head -n3
echo "---"

echo "==> Comment out the tty's, there is no access to them, waist of memory."
echo "---"
cat -n /etc/inittab |awk 'NR >= 9 && NR <= 14'
sed -i -r 's/^(tty[[:digit:]])/# \1/' /etc/inittab
echo "---"
cat -n /etc/inittab |awk 'NR >= 9 && NR <= 14'
echo "---"

# cat /etc/inittab

echo "==> Need to restart ish before adding sshd to OpenRC"
exit
##### END OF SSH SET-UP ######################################################
##### END OF reinstall-core-ish-apps.sh ######################################
##############################################################################


####### AFTER RESTART ########################################################
## new script ###
##############################################################################
rc-update add sshd  # add sshd to services

apk add curl        # URL retrival utility and library
                    # https://curl.se/


apk add awake       # python command and library to 'wake on lan' a remote host
                    # https://github.com/cyraxjoe/awake
                    
