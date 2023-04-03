# iSH

## Notes about iSH and SSH configuration on iPad and Mac 


```bash
# wright to README.md from cli using sed.
iPad: sed -i '18i \\n## Install glow - md viewer\napk add glow' README.md 
```
## SSH Configuration

> Note:  
 	Mac Prompt:      `mac:`    
	iPad prompt:     `ipad:`     

### Intro, Basics from MAN Pages
	~/.ssh/
		default location for all user-specific
		configuration and authentication information.  
		permissions are r/w/x for user, none for otheres
```txt	
drwx------    5 root     root         160 Dec  9 13:07 .ssh/
```
	~/.ssh/id_rsa
		Contains the private key for authentication.  
		Should be readable by the user but not
		accessible by others.   
		!!! ssh will IGNORE a private key file if it is accessible by others.	
```txt
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
ipad: cat ~/.ssh known_hosts
# truncuted for redability.
192.168.0.94 ecdsa-sha2-nistp256 AAAAE2VijZHNhLX...T+0=
github.com,140.82.121.3 ecdsa-sha2-nistp256 AAAAE2V0U2...wockg=
140.82.121.4 ecdsa-sha2-nistp256 AAAAE2VjTY.../++Tpockg=
```
### Run an SSH Server on iOS.

ipad:  
```bash
apk add openssh    # install ssh and ssh server. 
ssh-keygen -A      # create host keys (no questions asks!) 
passwd             # set a password for root to protect your iOS device 
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config  # modified config for root login. 
/usr/sbin/sshd     # start ssh daemon
```
You should now be able to ssh to your device with username root and the password you typed.

#### First Time ssh from Mac to iPad:

#### On Mac:

```bash
mac: ssh root@192.168.0.24
ssh: connect to host 192.168.0.24 port 22: Connection refused
```
If connection refused go back to iPad and restart ssh  
```bash
ipad: /usr/sbin/sshd    # start ssh server
```

> NOTE: one can only ssh to iPad when /usr/sbin/sshd is ON on iPad. 

Next try (ssh from Mac to iPad):
```bash
mac: ssh root@192.168.0.24
The authenticity of host '192.168.0.24 (192.168.0.24)' can't be established.  
ECDSA key fingerprint is SHA256:JVK7lKOF+6xoDoYGWC0L/ZG8CxY9DfUPN4An6/vqZ5s.  
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes  
Warning: Permanently added '192.168.0.24' (ECDSA) to the list of known hosts.  
root@192.168.0.24's password:  # type root password 
Welcome to Alpine!  
```
> NOTE: iPad can close connection at any time.
>       Hack to keep iPad session alife: 
>       ipad:  `cat /dev/location > /dev/null &`


### SSH from the same device (not tested yet)
If you are trying to connect via ssh from the same device, make sure you set the port configuration of sshd to use a non standard one (greater than 1024, eg: 22000).
You can do this by editing `/etc/ssh/sshd_config` and set `Port 22000` (Replace _22000_ with any non-standard port).
After this, you can ssh (from iSH itself) using `ssh root@localhost -p 22000`

## PasswordLess login from iPad to Mac

ipad: cd /root/.ssh

```ipad: ssh-keygen -C 'ipad-2-mac'```

```
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): /root/.ssh/id_rsa_ipad-2-mac
Enter passphrase (empty for no passphrase): # press Enter
Enter same passphrase again: # press Enter
Your identification has been saved in /root/.ssh/id_rsa_ipad-2-mac
Your public key has been saved in /root/.ssh/id_rsa_ipad-2-mac.pub
The key fingerprint is:
SHA256:7zjL/+39j28PSYj4s156+VK4tkoL6djOfJ8EXvmSo6E ipad-2-mac
The key's randomart image is:
+---[RSA 3072]----+
|                 |
|                 |
|                 |
|         . . o   |
|        S o +..  |
|         = o.+.. |
|        o B *++  |
|       B.*.X*= +.|
|      ..E*X*===oX|
+----[SHA256]-----+
```

#### Copy public key from iPad to Mac

> **NOTE:*** To copy anything  or login from client to server you MUST enable `Remote Login` on Mac.

## ON MAC

To enable remote login for members of the admin group enter:   

```sudo systemsetup -setremotelogin on```

or do it from a GUI.

check if it is turned on:
`sudo systemsetup -getremotelogin`

```
Remote Login: On
```

#### Alternative way of starting and stoping ssh on Mac.

start ssh  
```sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist```

stop ssh  
```sudo launchctl unload  /System/Library/LaunchDaemons/ssh.plist``` 

#### Try to copy public key from iPad to Mac

ipad:  
```scp ~/.ssh/id_rsa_ipad-2-mac.pub januszoles@192.168.0.94:/Users/januszoles/.ssh/id_rsa_ipad-2-mac.pub```

```
Password:
id_rsa_ipad-2-mac.pub                                                        100%  557    17.6KB/s   00:00    
```
#### Login from iPad to Mac

iPad:  
```ssh januszoles@192.168.0.94```
```
Password:
Last login: Thu Dec 16 09:10:30 2021
```
#### After succesfull login to Mac

```bash
 ➜ ls -Al ~/.ssh
-rw-r--r--    1 januszoles  staff   557 Dec 16 09:14 id_rsa_ipad-2-mac.pub
-rw-r--r--    1 januszoles  staff  1692 Dec 16 00:03 known_hosts
```

### Append iPad public key to `authorized_keys` file

> NOTE: if `authorized_keys` file not exist this command will create it.

```bash
cat ~/.ssh/id_rsa_ipad-2-mac.pub >> ~/.ssh/authorized_keys
```
```bash
mac: ls -Al ~/.ssh
-rw-r--r--    1 januszoles  staff   557 Dec 16 09:19 authorized_keys
-rw-r--r--    1 januszoles  staff   557 Dec 16 09:14 id_rsa_ipad-2-mac.pub
-rw-r--r--    1 januszoles  staff  1692 Dec 16 00:03 known_hosts
```
```bash
mac: cat ~/.ssh/authorized_keys    # check file                                
ssh-rsa A####...####= ipad-2-mac
```
```bash
mac: exit
Connection to 192.168.0.94 closed.
```
### On iPad 

``` bash
# [-L]ist all private keys on iPad:
iPad: ssh-add -L
Could not open a connection to your authentication agent.
```
```bash
# Starts ssh-agent for shell use.
iPad: eval `ssh-agent -s`  
Agent pid 54
```
```bash
iPad: ssh-add -L
The agent has no identities.
```
```bash
# Add private keys to ssh-agent
iPad: ssh-add /root/.ssh/id_rsa_ipad-2-mac
Identity added: /root/.ssh/id_rsa_ipad-2-mac (ipad-2-mac)
```

```bash
iPad: ssh-add -L
ssh-rsa A#####...####= ipad-2-mac
```
Now I can login to Mac without password. 

## Create host config file to simplify login

> NOTE: `~/.ssh/config`  DOES NOT exist by default.

```bash
iPad: cat << EOF > /root/.ssh/config
Host mac
    Hostname 192.168.0.94
    Port 22
    User januszoles
EOF
```

Now I can login to my mac by typing:
```bash
ssh mac
```

Next, create config on my **mac** so I could ssh to my ipad by typing: `ssh ipad`

### ON mac: Create public/private keys for mac-2-ipad connection

```mac: cd ~/.ssh/```
 
 ```mac: ssh-keygen -C 'mac-2-ipad'```
  
  ```
  Generating public/private rsa key pair.
  Enter file in which to save the key (/Users/januszoles/.ssh/id_rsa): id_rsa_mac-2-ipad
  Enter passphrase (empty for no passphrase): 
  Enter same passphrase again: 
  Your identification has been saved in id_rsa_mac-2-ipad.
  Your public key has been saved in id_rsa_mac-2-ipad.pub.
  The key fingerprint is:
  SHA256:7gknTQ00NDr7xXnA8vAD3Zcu5yw4Ek47QMYuFk2qpyo mac-2-ipad
  The key's randomart image is:
  +---[RSA 3072]----+
  |      ..=        |
  |     = o = .   . |
  |    o B = + . o  |
  |   . = o X o o   |
  |  . + + S O o o  |
  |   + . O + + =   |
  |  .   o X o . o  |
  |E.     = + . .   |
  |o       o        |
  +----[SHA256]-----+
  ```
  mac: ~/.ssh/   
   ➜ `ls -Al` 
   ```
   -rw-r--r--  1 januszoles  staff   557B Dec 16 09:19 authorized_keys
   -rw-r--r--  1 januszoles  staff   271B Dec 19 01:21 config
   -rw-------  1 januszoles  staff   2.5K Dec 20 23:19 id_rsa_mac-2-ipad
   -rw-r--r--  1 januszoles  staff   564B Dec 20 23:19 id_rsa_mac-2-ipad.pub
   -rw-r--r--  1 januszoles  staff   1.7K Dec 16 00:03 known_hosts
   ```
#### Edit mac:~/.ssh/config file   
```vim confg```

```
Host ipad
    Hostname 192.168.0.24
    Port 22
    IdentityFile ~/.ssh/id_rsa_mac-2-ipad
    User root
```

#### Copy public key to ipad  
mac: ~/.ssh/  
```scp ./id_rsa_mac-2-ipad.pub ipad:/root/.ssh/id_rsa_mac-2-ipad.pub```
```
    root@192.168.0.24's password: 
    id_rsa_mac-2-ipad.pub                                                 100%  564    35.7KB/s   00:00
```

## ON IPAD

### Copy mac public key to authorized_key file
iPad:~/.ssh#   
```cat id_rsa_mac-2-ipad.pub >> authorized_keys```  

#### ipad:/root/.ssh/config file

```bash
# IdentityFile points to location where the privet key for mac login is.
Host mac
    Hostname 192.168.0.94
    Port 22
    IdentityFile ~/.ssh/id_rsa_ipad-2-mac
    User januszoles
``` 

iPad:~/.ssh# ls -Al  

```
-rw-r--r--    1 root     root           564 Dec 20 22:40 authorized_keys
-rw-r--r--    1 root     root           102 Dec 18 09:05 config
-rw-------    1 root     root          2590 Dec 16 07:57 id_rsa_ipad-2-mac
-rw-r--r--    1 root     root           564 Dec 20 22:34 id_rsa_mac-2-ipad.pub
-rw-r--r--    1 root     root           557 Dec 16 07:57 id_rsa_ipad-2-mac.pub
-rw-r--r--    1 root     root           533 Dec  9 18:21 known_hosts
```

## Add SSHD to OpenRC so it starts when you open the iSH.app

1. What is OpenRC?

ipad:~# `apk info openrc`

	openrc-0.43.3-r2 description:
	OpenRC manages the services, startup and shutdown of a host

	openrc-0.43.3-r2 webpage:
	https://github.com/OpenRC/openrc

	openrc-0.43.3-r2 installed size:
	2528 KiB


2. Try if rc-update is installed. 

ipad:~# `rc-update`

	-ash: rc-update: not found

3. Install

ipad~# `apk add openrc`

4. Edit  `/etc/inittab` 

ipad :~# `vim /etc/inittab` 

find:
```
::sysinit:/sbin/openrc sysinit
```
change to:
```
::sysinit:/sbin/openrc
```
```
# /etc/inittab

::sysinit:/sbin/openrc
::sysinit:/sbin/openrc boot
::wait:/sbin/openrc default
tty1::respawn:/sbin/getty 38400 tty1
::ctrlaltdel:/sbin/reboot
::shutdown:/sbin/openrc shutdown
```

05. Restart iSH

ipad:~# `exit`

06. Check status

ipad:~# `rc-status` 	 

    Runlevel: sysinit. 
    Dynamic Runlevel: hotplugged  
    Dynamic Runlevel: needed/wanted  
    Dynamic Runlevel: manual  

7. Add sshd to sysinit 

ipad:~# `rc-update add sshd`  

	* service sshd added to runlevel sysinit

8. Check

iPad:~# `rc-status`

	Runlevel: sysinit
	sshd                                     [  stopped  ]
	Dynamic Runlevel: hotplugged
	Dynamic Runlevel: needed/wanted
	Dynamic Runlevel: manual

9. Exit. Close the app and start iSH again

10. Check if sshd started

iPad:~# `rc-service sshd status`

	* status: started



## CONFIGURE GITHUB ON IPAD iSH 

### 1. Install git

Get info

```sh
iPad:# apk info git

git-2.32.0-r0 description:
Distributed version control system

git-2.32.0-r0 webpage:
https://www.git-scm.com/

git-2.32.0-r0 installed size:
12 MiB
```

Install

```sh
iPad: apk add git
```



### 2. Configure git

Setup user info used across all local repos:

```sh
$ git config --global user.name "januszoles"
```

Set an email address:

```sh
iPad:~# git config --global user.email "<my-email@example.com>"
```

Set coloring options for ease of use:

```sh
iPad:~# git config --global color.ui auto
```

Clone repo located at https://gerrit.wikimedia.org onto iPad:

```
iPad:~# git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/examples.git

Sample session:
```
iPad:~# cd
iPad:~# git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/examples.git
Cloning into 'git'...
remote: Total 1633 (delta 0), reused 1633 (delta 0)
Receiving objects: 100% (1633/1633), 781.81 KiB | 130.00 KiB/s, done.
Resolving deltas: 100% (1094/1094), done.
```

Check repo
```
iPad:~# cd git
iPad:~/git# ls
CODE_OF_CONDUCT.md      Gruntfile.js            i18n                    package.json
COPYING                 README.md               includes                sql
Example.i18n.alias.php  composer.json           modules                 tests
Example.i18n.magic.php  extension.json          package-lock.json
```
Remove colned repo:

```sh
iPad:~/git# cd
iPad:~# rm -rf ./git
```

Print git config:
```sh
iPad:~# git config -l
```
```
user.email=my-email@example.com
user.name=januszoles
init.defaultbranch=main
color.ui=auto
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
```

### Create ssh keys for Github

```sh
# create new private/public key pair to comunicat with github
iPad: ssh-keygen -t ed25519 -C "my-email@example.com" -f ~/.ssh/ed25519_ipad-github

# cat and copy public key to clipboard 
# NOTE: no `pbcopy` on Alpine Linux iSH, use mouse or finger :)
iPad: cat ~/.ssh/ed25519_ipad-github.pub
```

Go to page `https://github.com/settings/ssh/new` and paset your ssh public key.

## iPad: Append new host info to config file (to simplify login)

> NOTE: `~/.ssh/config`  DOES NOT exist by default.  
> NOTE: `~/.ssh/config`  MUST be: `-rw-------` (chmod 600)

```sh
# Check permission MUST be: `-rw-------`
iPad:~# ls -Al ~/.ssh/config
-rw-------    1 root     root           377 Mar 27 22:18 /root/.ssh/config
```

```sh
# if different:
iPad:~# chmod 600 ~/.ssh/config
```


Append GitHub info to the end of config file:

```sh
iPad:~# cat << EOF >> /root/.ssh/config
Host github.com
    IdentityFile ~/.ssh/ed25519_ipad-github
    User januszoles
EOF
```

Take a look:

```sh
iPad:~# cat ~/.ssh/config
```

Try to clone repo from github to your ipad using SSH:

```sh
iPad:~# git clone git@github.com:<username>/<repository>.git
```

