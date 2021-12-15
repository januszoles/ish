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
apk add vim
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
	~/.ssh/id_rsa.pub
		Contains the public key for authentication.  These files are not
		sensitive and can (but need not) be readable by anyone.

	~/.ssh/known_hosts
		Contains a list of host keys for all hosts the user has logged
		into that are not already in the systemwide list of known host
		keys. See sshd(8) for further details of the format of this file.

```bash
iPad:~/.ssh# cat known_hosts
# truncuted for redability.
192.168.0.94 ecdsa-sha2-nistp256 AAAAE2VijZHNhLX...T+0=
github.com,140.82.121.3 ecdsa-sha2-nistp256 AAAAE2V0U2...wockg=
140.82.121.4 ecdsa-sha2-nistp256 AAAAE2VjTY.../++Tpockg=

```

### run an ssh server on iOS.
```bash
apk add openssh  # install ssh and ssh server. 
ssh-keygen -A    # create host keys. 
passwd           # set a password for root to protect your iOS device 
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config  # modified config for root login. 
/usr/sbin/sshd   # start ssh demon
```

You should now be able to ssh to your device with username root and the password you typed.

### SSH from the same device

If you are trying to connect via ssh from the same device, make sure you set the port configuration of sshd to use a non standard one (greater than 1024, eg: 22000).

You can do this by editing `/etc/ssh/sshd_config` and set `Port 22000` (Replace _22000_ with any non-standard port).

After this, you can ssh (from iSH itself) using `ssh root@localhost -p 22000`

```
januszoles@192.168.0.94
history |grep ssh
cd .ssh
ssh-keygen -o
cat /root/.ssh/id_rsa.pub 
ssh-add /root/.ssh/id_rsa
ssh-keygen --help
less /etc/ssh/sshd_config 
/usr/sbin/sshd
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

