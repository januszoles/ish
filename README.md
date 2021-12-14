# iSH

This is a test.

## Install bash

```bash
apk update
apk upgrade

apk add bash
apk add bash-completion
```
```bash
$ cat /etc/shells
# valid login shells
/bin/sh
/bin/ash
/bin/bash
```
```bash
apk add python3
apk add openssh
apk add vim
apk add gcc
apk add rsync
apk add tree
apk add git
apk add glow
```
```bash
# wright to README.md from cli using sed.
sed -i '18i \\n## Install glow - md viewer\napk add glow' README.md 
```
```bash
apk add glow
fetch http://apk.ish.app/v3.12-2021-06-25/main/x86/APKINDEX.tar.gz
fetch http://apk.ish.app/v3.12-2021-06-24/community/x86/APKINDEX.tar.gz
(1/1) Installing glow (0.2.0-r1)
Executing busybox-1.31.1-r20.trigger
OK: 246 MiB in 56 packages
```
## ssh conf

	~/.ssh/
		default location for all user-specific
		configuration and authentication information.  
		permissions are r/w/x for user, none for otheres
```	
drwx------    5 root     root         160 Dec  9 13:07 .ssh/
```
	~/.ssh/id_rsa
		Contains the private key for authentication.  
		Should be readable by the user but not
		accessible by others (read/write/execute).   
		! ssh will *ignore* a private key file if it is accessible by others.	
```
-rw-------    1 root     root        2.5K Dec  9 13:07 id_rsa
-rw-r--r--    1 root     root         570 Dec  9 13:07 id_rsa.pub
-rw-r--r--    1 root     root         533 Dec  9 18:21 known_hosts
```
```bash

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
```

