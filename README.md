# iSH 

- [Welcome to Alpine on iPhone 6! (2023-04-12)](#iphone6)

- [Config GitHub on iPhone 6 (2023-04-13)](#iphone6-github) 


## My notes about iSH.app and SSH configuration on iPad and Mac

## SSH Configuration

> Note:  
	Mac Prompt:      `mac:`  
	iPad prompt:     `ipad:`  

### Intro, Basics from MAN Pages

```txt
~/.ssh/
    default location for all user-specific
    configuration and authentication information.  
    permissions are r/w/x for user, none for otheres
```

```txt
drwx------    5 root     root         160 Dec  9 13:07 .ssh/
```

```txt
~/.ssh/id_rsa
    Contains the private key for authentication.  
    Should be readable by the user but not
    accessible by others.   
    !!! ssh will IGNORE a private key file if 
    it is accessible by others.
```

```txt
-rw-------    1 root     root        2.5K Dec  9 13:07 id_rsa
-rw-r--r--    1 root     root         570 Dec  9 13:07 id_rsa.pub
-rw-r--r--    1 root     root         533 Dec  9 18:21 known_hosts
```

```txt
~/.ssh/id_rsa.pub
    Contains the public key for authentication.  
    These files are not sensitive and can (but need not) be 
    readable by anyone.

~/.ssh/known_hosts
  Contains a list of host keys for all hosts the user has logged
  into that are not already in the systemwide list of known host
  keys. See sshd(8) for further details of the format of this file.
```

ipad: `cat ~/.ssh known_hosts`

```sh
# truncuted for redability.
192.168.0.94 ecdsa-sha2-nistp256 AAAAE2VijZHNhLX...T+0=
github.com,140.82.121.3 ecdsa-sha2-nistp256 AAAAE2V0U2...wockg=
140.82.121.4 ecdsa-sha2-nistp256 AAAAE2VjTY.../++Tpockg=
```

### Run an SSH Server on iOS

ipad:

```sh
apk add openssh    # install ssh and ssh server. 
ssh-keygen -A      # create host keys (no questions asks!) 
passwd             # set a password for root to protect your iOS device 
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config  # modified config for root login. 
/usr/sbin/sshd     # start ssh daemon
```

You should now be able to ssh to your device with username root and the password you typed.

#### First Time ssh from Mac to iPad:

mac: `ssh root@192.168.0.24`

```output
ssh: connect to host 192.168.0.24 port 22: Connection refused
```

> If connection refused, go back to iPad and restart ssh  

ipad: `/usr/sbin/sshd    # start ssh server`

> NOTE: one can only ssh to iPad when /usr/sbin/sshd is ON on iPad. 

Next try (ssh from Mac to iPad):

mac: `ssh root@192.168.0.24`

```output
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

ipad: `cd /root/.ssh`  

ipad: `ssh-keygen -C 'ipad-2-mac'`

```output
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

### Copy public key from iPad to Mac

> **NOTE:** To copy anything or to login from client to server you MUST enable `Remote Login` on Mac.

## ON MAC

To enable remote login for members of the admin group enter:

mac: `sudo systemsetup -setremotelogin on`

or do it from a GUI.

check if it is turned on:

mac: `sudo systemsetup -getremotelogin`

```output
Remote Login: On
```

### Alternative Way of Starting and Stoping ssh on Mac

start ssh
  
mac: `sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist`

stop ssh  

mac: `sudo launchctl unload  /System/Library/LaunchDaemons/ssh.plist` 

### Try to copy public key from iPad to Mac

ipad: `scp ~/.ssh/id_rsa_ipad-2-mac.pub januszoles@192.168.0.94:/Users/januszoles/.ssh/id_rsa_ipad-2-mac.pub`  

```output
Password:
id_rsa_ipad-2-mac.pub                                                        100%  557    17.6KB/s   00:00    
```

### Login from iPad to Mac

ipad:  `ssh januszoles@192.168.0.94`

```output
Password:
Last login: Thu Dec 16 09:10:30 2021
```

#### After succesfull login to Mac

```sh
 ➜ ls -Al ~/.ssh
-rw-r--r--    1 januszoles  staff   557 Dec 16 09:14 id_rsa_ipad-2-mac.pub
-rw-r--r--    1 januszoles  staff  1692 Dec 16 00:03 known_hosts
```

### Append iPad public key to `authorized_keys` file

> **NOTE:** if `authorized_keys` file NOT exist this command will create it.

```sh
cat ~/.ssh/id_rsa_ipad-2-mac.pub >> ~/.ssh/authorized_keys
```

mac: `ls -Al ~/.ssh`

```output
-rw-r--r--    1 januszoles  staff   557 Dec 16 09:19 authorized_keys
-rw-r--r--    1 januszoles  staff   557 Dec 16 09:14 id_rsa_ipad-2-mac.pub
-rw-r--r--    1 januszoles  staff  1692 Dec 16 00:03 known_hosts
```

mac: `cat ~/.ssh/authorized_keys    # check file`

```output
ssh-rsa A####...####= ipad-2-mac
```

mac: `exit`

```output
Connection to 192.168.0.94 closed.
```

### On iPad

#### Adds Private Key to the Authentication Agent

> **NOTE:**   
> **ssh-add** -- adds private key identities to the authentication agent 

```txt
-L    Lists public key parameters of all identities currently  
      represented by the agent.
```

ipad: `ssh-add -L`

```output
Could not open a connection to your authentication agent.
```

Starts ssh-agent for shell use.

ipad:

```sh
eval `ssh-agent -s`  
```
```
Agent pid 54
```


ipad: `ssh-add -L`

```output
The agent has no identities.
```

Add private keys to ssh-agent

ipad: `ssh-add /root/.ssh/id_rsa_ipad-2-mac`

```output
Identity added: /root/.ssh/id_rsa_ipad-2-mac (ipad-2-mac)
```

ipad: `ssh-add -L`

```output
ssh-rsa A#####...####= ipad-2-mac
```

Now I can login to Mac without password. 

## Create host config file to simplify login

> NOTE: `~/.ssh/config`  DOES NOT exist by default.


ipad:

```sh
cat << EOF > /root/.ssh/config
Host mac
    Hostname 192.168.0.94
    Port 22
    User januszoles
EOF
```

Now I can login to my mac by typing:

ipad: `ssh mac`

Next, create config on my **mac** so I could ssh to my ipad by typing: `ssh ipad`

### ON mac: Create public/private keys for mac-2-ipad connection

mac: `cd ~/.ssh/`

mac: `ssh-keygen -C 'mac-2-ipad'`
  
```txt
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

mac:  `ls -Al ~/.ssh`

```output
   -rw-r--r--  1 januszoles  staff   557B Dec 16 09:19 authorized_keys
   -rw-r--r--  1 januszoles  staff   271B Dec 19 01:21 config
   -rw-------  1 januszoles  staff   2.5K Dec 20 23:19 id_rsa_mac-2-ipad
   -rw-r--r--  1 januszoles  staff   564B Dec 20 23:19 id_rsa_mac-2-ipad.pub
   -rw-r--r--  1 januszoles  staff   1.7K Dec 16 00:03 known_hosts
```

#### Edit mac:~/.ssh/config file

mac: `vim ~/.ssh/confg`

add this to config:

```txt
Host ipad
    Hostname 192.168.0.24
    Port 22
    IdentityFile ~/.ssh/id_rsa_mac-2-ipad
    User root
```

#### Copy public key to ipad

mac: `cd ~/.ssh/`  

mac: `scp ./id_rsa_mac-2-ipad.pub ipad:/root/.ssh/id_rsa_mac-2-ipad.pub`

```output
    root@192.168.0.24's password: 
    id_rsa_mac-2-ipad.pub                                                 100%  564    35.7KB/s   00:00
```

## ON IPAD

### Copy mac public key to authorized_key file

ipad:

```sh 
cat ~/.ssh id_rsa_mac-2-ipad.pub >> authorized_keys
```  

#### ipad:/root/.ssh/config file

```sh
# IdentityFile points to location where the privet key for mac login is.
Host mac
    Hostname 192.168.0.94
    Port 22
    IdentityFile ~/.ssh/id_rsa_ipad-2-mac
    User januszoles
``` 

ipad:~/.ssh# `ls -Al`  

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

ipad: `apk info openrc`

```output
openrc-0.43.3-r2 description:
OpenRC manages the services, startup and shutdown of a host

openrc-0.43.3-r2 webpage:
https://github.com/OpenRC/openrc

openrc-0.43.3-r2 installed size:
2528 KiB
```

2. Try if rc-update is installed.

ipad: `rc-update`

```output
-ash: rc-update: not found
```

3. Install

ipad: `apk add openrc`

4. Edit  `/etc/inittab`

ipad: `vi /etc/inittab`

find:

```txt
# /etc/inittab

::sysinit:/sbin/openrc sysinit
```

change to:

```txt
# /etc/inittab

::sysinit:/sbin/openrc
```

```txt
# /etc/inittab

::sysinit:/sbin/openrc
::sysinit:/sbin/openrc boot
::wait:/sbin/openrc default
tty1::respawn:/sbin/getty 38400 tty1
::ctrlaltdel:/sbin/reboot
::shutdown:/sbin/openrc shutdown
```

05. Restart iSH

ipad: `exit`

06. Check status

ipad: `rc-status`

```
Runlevel: sysinit. 
Dynamic Runlevel: hotplugged  
Dynamic Runlevel: needed/wanted  
Dynamic Runlevel: manual  
```

7. Add sshd to sysinit

ipad: `rc-update add sshd`  

```
	* service sshd added to runlevel sysinit
```

8. Check

ipad: `rc-status`

	Runlevel: sysinit
	sshd                                     [  stopped  ]
	Dynamic Runlevel: hotplugged
	Dynamic Runlevel: needed/wanted
	Dynamic Runlevel: manual

9. Exit. Close the app and start iSH again

10. Check if sshd started

ipad: `rc-service sshd status`

	* status: started



## CONFIGURE GITHUB ON IPAD iSH

### 1. Install git

Get info

ipad: `apk info git`

```output
git-2.32.0-r0 description:
Distributed version control system

git-2.32.0-r0 webpage:
https://www.git-scm.com/

git-2.32.0-r0 installed size:
12 MiB
```

Install

ipad: `apk add git`


### 2. Configure git

Setup user info used across all local repos:

ipad: `git config --global user.name "januszoles"`

Set an email address:

ipad: `git config --global user.email "<my-email@example.com>"`

Set coloring options for ease of use:

ipad: `git config --global color.ui auto`

Clone repo located at https://gerrit.wikimedia.org onto iPad:

ipad: `git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/examples.git`

Sample session:

ipad: `cd`

ipad: `git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/examples.git`

```output
Cloning into 'git'...
remote: Total 1633 (delta 0), reused 1633 (delta 0)
Receiving objects: 100% (1633/1633), 781.81 KiB | 130.00 KiB/s, done.
Resolving deltas: 100% (1094/1094), done.
```

Check repo

ipad: `cd git`

ipad: `ls`

```output
CODE_OF_CONDUCT.md      Gruntfile.js            i18n                    package.json
COPYING                 README.md               includes                sql
Example.i18n.alias.php  composer.json           modules                 tests
Example.i18n.magic.php  extension.json          package-lock.json
```

Remove cloned repo:

ipad: `cd`

ipad: `rm -rf ./git`

Print git config:

ipad: `git config -l`

```output
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

create new private/public key pair to comunicat with github

ipad:

```sh
ssh-keygen -t ed25519 -C "my-email@example.com" -f ~/.ssh/ed25519_ipad-github
```

cat and copy public key to clipboard

> **NOTE:** no `pbcopy` on Alpine Linux iSH, use mouse or finger :)

ipad: `cat ~/.ssh/ed25519_ipad-github.pub`

Go to page `https://github.com/settings/ssh/new` and paste your ssh public key.

## ipad: Append new host info to config file (to simplify login)

> NOTE: `~/.ssh/config`  DOES NOT exist by default.  
> NOTE: `~/.ssh/config`  MUST be: `-rw-------` (chmod 600)

### Check permission MUST be: `-rw-------`

ipad: `ls -Al ~/.ssh/config`

```output
-rw-------    1 root     root           377 Mar 27 22:18 /root/.ssh/config
```

if different:

ipad: `chmod 600 ~/.ssh/config`

Append GitHub info to the end of config file:

ipad:

```sh
cat << EOF >> /root/.ssh/config
Host github.com
    IdentityFile ~/.ssh/ed25519_ipad-github
    User januszoles
EOF
```

Take a look:

ipad: `cat ~/.ssh/config`

Try to clone repo from github to your ipad using SSH:

ipad: `git clone git@github.com:<username>/<repository>.git`


***

<div id='iphone6'/>

# Welcome to Alpine on iPhone 6! (2023-04-12)

## History of Installation and Configuration of iSH Alpine Linux on my old iPhone 6 running iOS 12.5.7.
No external keyboard was available.
The Apple external Bluetooth keyboard A1314 was not listed as a device on my iPhone 6.

The idea was to install and configure SSH and some other tools, so that I could log in to my iPhone from my iPad via SSH and have the possibility to use an external keyboard or from my Mac.
This was just to learn a little bit more about SSH and Git.

Here are the step-by-step instructions, including the wrong steps that were taken.
```
Welcome to Alpine!

You can install packages with: apk add <package>

You may change this message by editing /etc/motd.

iPhone6:~#
```

What do I have here?
```
iPhone6:~# apk info
WARNING: Ignoring https://dl-cdn.alpinelinux.org/alpine/v3.14/main: No such file or directory
WARNING: Ignoring https://dl-cdn.alpinelinux.org/alpine/v3.14/community: No such file or directory
musl
busybox
alpine-baselayout
alpine-keys
libcrypto1.1
libssl1.1
ca-certificates-bundle
libretls
ssl_client
zlib
apk-tools
scanelf
musl-utils
libc-utils
```

First things first!
```
iPhone6:~# apk update
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/main/x86/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/community/x86/APKINDEX.tar.gz
v3.14.10-12-gbc9180e8f5c [https://dl-cdn.alpinelinux.org/alpine/v3.14/main]
v3.14.10-11-gbe90e547195 [https://dl-cdn.alpinelinux.org/alpine/v3.14/community]
OK: 14630 distinct packages available
```

```
iPhone6:~# apk upgrade
(1/9) Upgrading musl (1.2.2-r3 -> 1.2.2-r4)
(2/9) Upgrading busybox (1.33.1-r6 -> 1.33.1-r8)
Executing busybox-1.33.1-r8.post-upgrade
(3/9) Upgrading libcrypto1.1 (1.1.1l-r0 -> 1.1.1t-r2)
(4/9) Upgrading libssl1.1 (1.1.1l-r0 -> 1.1.1t-r2)
(5/9) Upgrading ca-certificates-bundle (20191127-r5 -> 20220614-r0)
(6/9) Upgrading libretls (3.3.3p1-r2 -> 3.3.3p1-r3)
(7/9) Upgrading ssl_client (1.33.1-r6 -> 1.33.1-r8)
(8/9) Upgrading zlib (1.2.11-r3 -> 1.2.12-r3)
(9/9) Upgrading musl-utils (1.2.2-r3 -> 1.2.2-r4)
Executing busybox-1.33.1-r8.trigger
Executing ca-certificates-20220614-r0.trigger
OK: 41 MiB in 34 packages
```

Trying to add man pages by try and error 
```
iPhone6:~# apk add man
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/main/x86/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/community/x86/APKINDEX.tar.gz
ERROR: unable to select packages:
  man (no such package):
    required by: world[man]
```    

```
iPhone6:~# apk add man-pages
(1/1) Installing man-pages (5.11-r0)
OK: 22 MiB in 15 packages
```

```
iPhone6:~# apk add mandoc
(1/1) Installing mandoc (1.14.5-r5)
Executing busybox-1.33.1-r6.trigger
OK: 22 MiB in 16 packages
iPhone6:~# mam man
-ash: mam: not found
```

```
iPhone6:~# apk add mandoc-apropos less less-doc
(1/5) Installing ncurses-terminfo-base (6.2_p20210612-r1)
(2/5) Installing ncurses-libs (6.2_p20210612-r1)
(3/5) Installing less (581-r2)
(4/5) Installing less-doc (581-r2)
(5/5) Installing mandoc-apropos (1.14.5-r5)
Executing busybox-1.33.1-r6.trigger
Executing mandoc-apropos-1.14.5-r5.trigger
OK: 23 MiB in 21 packages
```

Finally
```
iPhone6:~# man ls
```

Add rsync just in case
```
iPhone6:~# apk add rsync rsync-doc
(1/5) Installing libacl (2.2.53-r0)
(2/5) Installing popt (1.18-r0)
(3/5) Installing zstd-libs (1.4.9-r1)
(4/5) Installing rsync (3.2.5-r0)
(5/5) Installing rsync-doc (3.2.5-r0)
Executing busybox-1.33.1-r6.trigger
Executing mandoc-apropos-1.14.5-r5.trigger
OK: 24 MiB in 26 packages
```

Add git
```
iPhone6:~# apk info git
git-2.32.6-r0 description:
Distributed version control system

git-2.32.6-r0 webpage:
https://www.git-scm.com/

git-2.32.6-r0 installed size:
12 MiB
```

How to search just for an app name
```
iPhone6:~# apk -e search git
git-2.32.6-r0
```

```
iPhone6:~# apk add git
(1/7) Installing ca-certificates (20220614-r0)
(2/7) Installing brotli-libs (1.0.9-r5)
(3/7) Installing nghttp2-libs (1.43.0-r0)
(4/7) Installing libcurl (7.79.1-r5)
(5/7) Installing expat (2.5.0-r0)
(6/7) Installing pcre2 (10.36-r1)
(7/7) Installing git (2.32.6-r0)
100% ███████████████████████████████████████████Executing ca-certificates-20220614-r0.trigger
OK: 40 MiB in 33 packages
```

```
iPhone6:~# man git
man: No entry for git in the manual.
```

```
iPhone6:~# apk search git | grep doc
lazygit-doc-0.28.2-r2
git-interactive-rebase-tool-doc-2.1.0-r0
cgit-doc-1.2.3-r0
git-flow-doc-1.12.3-r0
git-crypt-doc-0.6.0-r1
gitg-doc-3.32.1-r6
git-review-doc-1.28.0-r5
git-doc-2.32.6-r0          # <——————— that’s the one
git-lfs-doc-2.13.1-r1
github-cli-doc-2.1.0-r1
stagit-doc-0.9.6-r0
git-subtree-doc-2.32.6-r0
```

```
iPhone6:~# apk add git-doc
(1/1) Installing git-doc (2.32.6-r0)
Executing mandoc-apropos-1.14.5-r5.trigger
OK: 41 MiB in 34 packages
```

iPhone6:~# man git
```
GIT(1)             Git Manual             GIT(1)



 

NAME
   git - the stupid content tracker

SYNOPSIS
   git [--version] [--help] [-C <path>] [-c <name>=<value>]
       [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
       [-p|--paginate|-P|--no-pager] [--no-replace-objects] [--bare]
       [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
       [--super-prefix=<path>] [--config-env=<name>=<envvar>]
       <command> [<args>]
```

```
iPhone:~# git --help
usage: git [--version] [--help] [-C <path>] [-c <name>=<value>]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           [--super-prefix=<path>] [--config-env=<name>=<envvar>]
           <command> [<args>]

These are common Git commands used in various situations:

start a working area (see also: git help tutorial)
   clone             Clone a repository into a new directory
   init              Create an empty Git repository or reinitialize an existing one

work on the current change (see also: git help everyday)
   add               Add file contents to the index
   mv                Move or rename a file, a directory, or a symlink
   restore           Restore working tree files
   rm                Remove files from the working tree and from the index
   sparse-checkout   Initialize and modify the sparse-checkout 

examine the history and state (see also: git help revisions)
   bisect            Use binary search to find the commit that introduced a bug
   diff              Show changes between commits, commit and working tree, etc
   grep              Print lines matching a pattern
   log               Show commit logs
   show              Show various types of objects
   status            Show the working tree status

grow, mark and tweak your common history
   branch            List, create, or delete branches
   commit            Record changes to the repository
   merge             Join two or more development histories together
   rebase            Reapply commits on top of another base tip
   reset             Reset current HEAD to the specified state
   switch            Switch branches
   tag               Create, list, delete or verify a tag object signed with GPG

collaborate (see also: git help workflows)
   fetch             Download objects and refs from another repository
   pull              Fetch from and integrate with another repository or a local branch
   push              Update remote refs along with associated objects

'git help -a' and 'git help -g' list available subcommands and some
concept guides. See 'git help <command>' or 'git help <concept>'
to read about a specific subcommand or concept.
See 'git help git' for an overview of the system.
```

I don’t remember what I did but it listed all commands, so I keep them here just for reference.

```
.                       man
:                       mandoc
[                       md5sum
[[                      mdev
acpid                   mesg
add-shell               microcom
addgroup                mkdir
adduser                 mkdosfs
adjtimex                mkfifo
alias                   mkfs.vfat
apk                     mkmntdirs
apropos                 mknod
arch                    mkpasswd
arp                     mkswap
arping                  mktemp
ash                     modinfo
awk                     modprobe
base64                  more
basename                mount
bbconfig                mountpoint
bc                      mpstat
beep                    mv
bg                      nameif
blkdiscard              nanddump
blkid                   nandwrite
blockdev                nbd-client
brctl                   nc
break                   netstat
bunzip2                 nice
busybox                 nl
bzcat                   nmeter
bzip2                   nohup
c_rehash                nologin
cal                     nproc
cat                     nsenter
cd                      nslookup
chdir                   ntpd
chgrp                   od
chmod                   openvt
chown                   partprobe
chpasswd                passwd
chroot                  paste
chvt                    pgrep
cksum                   pidof
clear                   ping
cmp                     ping6
comm                    pipe_progress
command                 pivot_root
continue                pkill
cp                      pmap
cpio                    poweroff
crond                   printenv
crontab                 printf
cryptpw                 ps
cut                     pscan
date                    pstree
dc                      pwd
dd                      pwdx
deallocvt               raidautorun
delgroup                rdate
deluser                 rdev
demandoc                read
depmod                  readahead
df                      readlink
diff                    readonly
dirname                 realpath
dmesg                   reboot
dnsdomainname           reformime
dos2unix                remove-shell
du                      renice
dumpkmap                reset
echo                    resize
ed                      return
egrep                   rev
eject                   rfkill
env                     rm
ether-wake              rmdir
eval                    rmmod
exec                    route
exit                    rsync
expand                  rsync-ssl
export                  run-parts
expr                    scanelf
factor                  sed
fallocate               sendmail
false                   seq
fatattr                 set
fbset                   setconsole
fbsplash                setfont
fdflush                 setkeycodes
fdisk                   setlogcons
fg                      setpriv
fgrep                   setserial
find                    setsid
findfs                  sh
flock                   sha1sum
fold                    sha256sum
free                    sha3sum
fsck                    sha512sum
fstrim                  shift
fsync                   showkey
fuser                   shred
getconf                 shuf
getent                  slattach
getopt                  sleep
getopts                 sort
getty                   source
git                     split
git-receive-pack        ssl_client
git-shell               stat
git-upload-archive      strings
git-upload-pack         stty
grep                    su
groups                  sum
gunzip                  swapoff
gzip                    swapon
halt                    switch_root
hash                    sync
hd                      sysctl
head                    syslogd
help                    tac
hexdump                 tail
history                 tar
hostid                  tee
hostname                test
hwclock                 time
iconv                   timeout
id                      times
ifconfig                top
ifdown                  touch
ifenslave               tr
ifup                    traceroute
init                    traceroute6
inotifyd                trap
insmod                  true
install                 truncate
ionice                  tty
iostat                  ttysize
ip                      tunctl
ipaddr                  type
ipcalc                  udhcpc
ipcrm                   udhcpc6
ipcs                    ulimit
iplink                  umask
ipneigh                 umount
iproute                 unalias
iprule                  uname
iptunnel                unexpand
jobs                    uniq
kbd_mode                unix2dos
kill                    unlink
killall                 unlzma
killall5                unlzop
klogd                   unset
ldconfig                unshare
ldd                     unxz
less                    unzip
lessecho                update-ca-certificates
lesskey                 uptime
let                     usleep
link                    uudecode
linux32                 uuencode
linux64                 vconfig
ln                      vi
loadfont                vlock
loadkmap                volname
local                   wait
logger                  watch
login                   watchdog
logread                 wc
losetup                 wget
ls                      whatis
lsmod                   which
lsof                    whoami
lsusb                   whois
lzcat                   xargs
lzma                    xmlwf
lzop                    xxd
lzopcat                 xzcat
makemime                yes
makewhatis              zcat
```


Just checking, is it possible to install neovim on old iPhone6
```
iPhone6:~# apk search -e neovim
neovim-0.4.4-r1

```

Yes, it is.
```
iPhone6:~# apk add neovim
(1/10) Installing libintl (0.21-r0)
(2/10) Installing libgcc (10.3.1_git20210424-r2)
(3/10) Installing luajit (2.1_p20210510-r0)
(4/10) Installing libuv (1.41.0-r0)
(5/10) Installing libluv (1.36.0.0-r3)
(6/10) Installing msgpack-c (3.3.0-r0)
(7/10) Installing unibilium (2.1.0-r0)
(8/10) Installing libtermkey (0.22-r0)
(9/10) Installing libvterm (0.1.20190920-r1)
(10/10) Installing neovim (0.4.4-r1)
Executing busybox-1.33.1-r8.trigger
OK: 59 MiB in 44 packages
```

Install and config ssh
```
iPhone6:~# apk add openssh
(1/8) Installing openssh-keygen (8.6_p1-r3)
(2/8) Installing libedit (20210216.3.1-r0)
(3/8) Installing openssh-client-common (8.6_p1-r3)
(4/8) Installing openssh-client-default (8.6_p1-r3)
(5/8) Installing openssh-sftp-server (8.6_p1-r3)
(6/8) Installing openssh-server-common (8.6_p1-r3)
(7/8) Installing openssh-server (8.6_p1-r3)
(8/8) Installing openssh (8.6_p1-r3)
Executing busybox-1.33.1-r8.trigger
OK: 65 MiB in 52 packages
```

```
iPhone6:~# rc-update add sshd
-ash: rc-update: not found
```

```
iPhone6:~# apk add openrc
(1/3) Installing ifupdown-ng (0.11.3-r0)
(2/3) Installing openrc (0.43.3-r3)
Executing openrc-0.43.3-r3.post-install
(3/3) Installing rsync-openrc (3.2.5-r0)
100% ███████████████████████████████████████████OK: 68 MiB in 55 packages
K: 68 MiB in 55 packages
```

```
iPhone6:~# rc-update add sshd
 * service sshd added to runlevel sysinit
```

```
iPhone6:~# service sshd start
 * WARNING: sshd is already starting
```

```
iPhone6:~# passwd
Changing password for root
New password: 
Retype password: 
passwd: password for root changed by root
```

```
iPhone6:~# echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
```

```
iPhone6:~# tail -2 /etc/ssh/sshd_config
#       ForceCommand cvs server
PermitRootLogin yes
```

```bash
iPhone6:~# rc-status
 * Caching service dependencies ...
Service `hwdrivers' needs non existent service `dev'
Service `machine-id' needs non existent service `dev'                                       [ ok ]
Runlevel: sysinit
 sshd                               [  stopped  ]
Dynamic Runlevel: hotplugged
Dynamic Runlevel: needed/wanted
Dynamic Runlevel: manual
```

```
iPhone6:~# service sshd start
grep: /proc/filesystems: No such file or directory
 * You are attempting to run an openrc service on a
 *  * another initialization system to boot this system.
 * If you really want to do this, issue the following command:
 * ERROR: sshd failed to start
iPhone6:~# 
```

```
iPhone6:~# /usr/sbin/sshd
sshd: no hostkeys available -- exiting.
```

```
iPhone6:~# cat /etc/inittab
# /etc/inittab

::sysinit:/sbin/openrc sysinit
::sysinit:/sbin/openrc boot
::wait:/sbin/openrc default

# Set up a couple of getty's
tty1::respawn:/sbin/getty 38400 tty1
tty2::respawn:/sbin/getty 38400 tty2
tty3::respawn:/sbin/getty 38400 tty3
tty4::respawn:/sbin/getty 38400 tty4
tty5::respawn:/sbin/getty 38400 tty5
tty6::respawn:/sbin/getty 38400 tty6

# Put a getty on the serial port
#ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100

# Stuff to do for the 3-finger salute
::ctrlaltdel:/sbin/reboot

# Stuff to do before rebooting
::shutdown:/sbin/openrc shutdown
```

This is a tricky one, without an external keyboard
```
iPhone6:~# vi /etc/inittab
```

vi step by step on iPhone6 without external keyboard
```
# vi /etc/inittab

# navigation help
h - left
j - down
k - up
l - right

# (navigate) down, right, right, right...
jllll      

#                     place cursor here  
#                     | 
::sysinit:/sbin/openrc sysinit

# (d shift4) delete from curosr to the end of the line
d$         
::sysinit:/sbin/openrc

# write (save) and quit vi
:wq        

# otherwise quit without saving
:q!
```

```
iPhone6:~# cat /etc/inittab
# /etc/inittab

::sysinit:/sbin/openrc
::sysinit:/sbin/openrc boot
::wait:/sbin/openrc default
```

```
iPhone6:~# rc-status
Runlevel: sysinit
 sshd                               [  stopped  ]
Dynamic Runlevel: hotplugged
Dynamic Runlevel: needed/wanted
Dynamic Runlevel: manual
```

```
iPhone6:~# rc-update add sshd
 * rc-update: sshd already installed in runlevel `sysinit'; skipping

```

Close iSH.app completely and open again
```
iPhone6:~# exit
```

```
iPhone6:~# rc-service sshd status
 * status: starting
```


```
iPhone6:~# /usr/sbin/sshd
iPhone6:~# 
```

Test from iPad
```
iPad:~# ssh root@192.168.0.73
ssh: connect to host 192.168.0.73 port 22: Connection refused
iPad:~# ssh root@192.168.0.73
The authenticity of host '192.168.0.73 (192.168.0.73)' can't be established.
RSA key fingerprint is SHA256:Ktrk/h6j9Ti22oCo4VkyI5WWWpCQPPwlD7i9wymA2NQ.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.0.73' (RSA) to the list of known hosts.
root@192.168.0.73's password: 
Permission denied, please try again.
root@192.168.0.73's password: 
Welcome to Alpine!

You can install packages with: apk add <package>

You may change this message by editing /etc/motd.

iPhone6:~# 
```

It looks like it tries to install the last used or the newest one.
Never mind. (crl+C) to exit.
```
iPad:~# ssh-copy-id root@192.168.0.73
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa_ipad-2-j17.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
expr: warning: '^ERROR: ': using '^' as the first character
of a basic regular expression is not portable; it is ignored
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.0.73's password:
^c 
```

Generate new key
```
iPad:~/.ssh# ssh-keygen -C 'ipad' -f ~/.ssh/id_rsa_ipad
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa_ipad
Your public key has been saved in /root/.ssh/id_rsa_ipad.pub
The key fingerprint is:
SHA256:7E+hwO8uKa7E28XIfjW2ojkukGKipMB/xrh0eXpd+Wk ipad
The key's randomart image is:
+---[RSA 3072]----+
|                 |
|                 |
|                 |
|     . .         |
|..    o S . .    |
|*= . o.++. +     |
|O.+.=oo==oo . .  |
|o.o*+*Bo.+   E   |
|  o*@*.+o . .    |
+----[SHA256]-----+
```

Copy public key from iPad —> iPhone6 
It will be automatically added to ~/.ssh/authorize_keys 
and all files will be created on the fly.

```
iPad:~/.ssh# ssh-copy-id -i ~/.ssh/id_rsa_ipad.pub root@192.168.0.73
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa_ipad.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
expr: warning: '^ERROR: ': using '^' as the first character
of a basic regular expression is not portable; it is ignored
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.0.73's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@192.168.0.73'"
and check to make sure that only the key(s) you wanted were added.
```

```
iPhone6:~# exit
Connection to 192.168.0.73 closed.
```

```
iPad:~/.ssh# ssh-add -L
Could not open a connection to your authentication agent.
iPad:~/.ssh# 
```

```
iPad:~/.ssh# eval `ssh-agent -s`
Agent pid 131
```

```
iPad:~/.ssh# ssh-add ~/.ssh/id_rsa_ipad
Identity added: /root/.ssh/id_rsa_ipad (ipad)
```

```
iPad:~/.ssh# ssh root@192.168.0.73
Welcome to Alpine!
...
iPhone6:~# exit
Connection to 192.168.0.73 closed.

iPad:~/.ssh# 
```

<div id='iphone6-github'/>                                                                                                                                                                          

## Config GitHub on iPhone6 

New defaut key
```
iPhone6:~# ssh-keygen -t ed25519 -C "MY@EMAIL.COM"
```

Start the ssh-agent
```
iPhone6:~# eval "$(ssh-agent -s)"
```

Edit config
```
iPhone6:~# vi ~/.ssh/config 
```

Config:
```
iPhone6:~# cat ~/.ssh/config
#---------------------------------
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
#---------------------------------
```

List files
```
iPhone6:~# ls -1 ~/.ssh
> authorized_keys
> config
> id_ed25519
> id_ed25519.pub
> known_hosts
```

Add your SSH private key to the ssh-agent.
```
iPhone6:~# ssh-add ~/.ssh/id_ed25519
```

cat, copy and paste to  `https://github.com/settings/ssh/new`  Login first!
```
iPhone6:~# cat ~/.ssh/id_ed25519.pub 
```

Test an SSH connection 
```
iPhone6:~# ssh -T git@github.com
> Hi januszoles! You've successfully authenticated, but GitHub does not provide shell access.
```

Displays the fingerprints of all the keys that have been added to the SSH agent
```
iPhone6:~# ssh-add -l -E sha256
```

Verbose Test
```
iPhone6:~# ssh -vT git@github.com
```

Clone repo
```
iPhone6:~# git clone git@github.com:januszoles/ish.git
> Cloning into 'ish'...
...
```


