# iSH

This is a test.

## Install bash

```
apk update
apk upgrade

apk add bash
apk add bash-completion

```
```
$ cat /etc/shells
# valid login shells
/bin/sh
/bin/ash
/bin/bash
```
```
apk add python3
apk add openssh
apk add vim
106 apk add gcc
apk add rsync
apk add tree
apk add git
apk add glow
```
```
# wright to README.md from cli using sed.
sed -i '18i \\n## Install glow - md viewer\napk add glow' README.md 
```

apk add glow
fetch http://apk.ish.app/v3.12-2021-06-25/main/x86/APKINDEX.tar.gz
fetch http://apk.ish.app/v3.12-2021-06-24/community/x86/APKINDEX.tar.gz
(1/1) Installing glow (0.2.0-r1)
Executing busybox-1.31.1-r20.trigger
OK: 246 MiB in 56 packages


 apk add openssh
 ssh januszoles@192.168.0.94
 history |grep ssh
 cd .ssh
 ssh-keygen -o
 cat /root/.ssh/id_rsa.pub 
 ssh-add /root/.ssh/id_rsa
 ssh-keygen --help
 less /etc/ssh/sshd_config 
 which openssh
 echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config 
 /usr/sbin/sshd
 ssh-keygen -A
 cd .ssh/
 cat /root/.ssh/id_rsa.pub
 ssh git@github.com:januszoles/ish.git
 eval `ssh-agent -s`
 ssh-add
 eval "$(ssh-agent -s)"
 cd .ssh/
 ssh-add -K id_rsa
 eval `ssh-agent -s`
 ssh-add
 cd .ssh/
 history |grep ssh > ssh-notes.txt

