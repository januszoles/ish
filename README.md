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
iPad: cat /etc/shells
# valid login shells
/bin/sh
/bin/ash
/bin/bash
```
### Add more apks
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
iPad: sed -i '18i \\n## Install glow - md viewer\napk add glow' README.md 
```
## SSH Configuration

> Note:  
 	Mac Prompt:      `➜ `    
	iPad prompt:     `iPad:`     

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
		accessible by others (read/write/execute).   
		! ssh will *ignore* a private key file if it is accessible by others.	
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
iPad: cat ~/.ssh known_hosts
# truncuted for redability.
192.168.0.94 ecdsa-sha2-nistp256 AAAAE2VijZHNhLX...T+0=
github.com,140.82.121.3 ecdsa-sha2-nistp256 AAAAE2V0U2...wockg=
140.82.121.4 ecdsa-sha2-nistp256 AAAAE2VjTY.../++Tpockg=
```
### Run an SSH Server on iOS.

```bash
apk add openssh    # install ssh and ssh server. 
ssh-keygen -A      # create host keys (no questions asks!) 
passwd             # set a password for root to protect your iOS device 
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config  # modified config for root login. 
/usr/sbin/sshd     # start ssh demon
```
You should now be able to ssh to your device with username root and the password you typed.

#### First Time ssh from Mac to iPad:

On Mac:
```bash
➜ ssh root@192.168.0.24
ssh: connect to host 192.168.0.24 port 22: Connection refused
```
If connection refused go back to iPad and restart ssh  
```bash
iPad: /usr/sbin/sshd    # start ssh server
```

> NOTE: one can only ssh to iPad when /usr/sbin/sshd is ON on iPad. 

Next try to ssh from Mac to iPad:
```bash
➜ ssh root@192.168.0.24
The authenticity of host '192.168.0.24 (192.168.0.24)' can't be established.  
ECDSA key fingerprint is SHA256:JVK7lKOF+6xoDoYGWC0L/ZG8CxY9DfUPN4An6/vqZ5s.  
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes  
Warning: Permanently added '192.168.0.24' (ECDSA) to the list of known hosts.  
root@192.168.0.24's password:  # type root password 
Welcome to Alpine!  
```
> NOTE: iPad can close connection at any time.

### SSH from the same device (not tested yet)
If you are trying to connect via ssh from the same device, make sure you set the port configuration of sshd to use a non standard one (greater than 1024, eg: 22000).
You can do this by editing `/etc/ssh/sshd_config` and set `Port 22000` (Replace _22000_ with any non-standard port).
After this, you can ssh (from iSH itself) using `ssh root@localhost -p 22000`

## Configurte PasswordLess login from iPad to Mac

```bash
iPad: ssh-keygen -C 'J13'
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): /root/.ssh/id_rsa_j13
Enter passphrase (empty for no passphrase): # press Enter
Enter same passphrase again: # press Enter
Your identification has been saved in /root/.ssh/id_rsa_j13
Your public key has been saved in /root/.ssh/id_rsa_j13.pub
The key fingerprint is:
SHA256:7zjL/+39j28PSYj4s156+VK4tkoL6djOfJ8EXvmSo6E J13
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

```bash
iPad: scp ~/.ssh/id_rsa_j13.pub januszoles@192.168.0.94:/Users/januszoles/.ssh/id_rsa_j13.pub
Password:
id_rsa_j13.pub                                                        100%  557    17.6KB/s   00:00    
```
#### Login from iPad to Mac

```bash
iPad: ssh januszoles@192.168.0.94
Password:
Last login: Thu Dec 16 09:10:30 2021
```
#### After succesfull login to Mac

```bash
 ➜ ls -Al ~/.ssh
-rw-r--r--    1 januszoles  staff   557 Dec 16 09:14 id_rsa_j13.pub
-rw-r--r--    1 januszoles  staff  1692 Dec 16 00:03 known_hosts
```
### Append iPad public key to authorized_keys file

> NOTE: if not exist this command will create it.

```bash
➜ cat ~/.ssh/id_rsa_j13.pub >> ~/.ssh/authorized_keys
```
```bash
 ➜ ls -Al ~/.ssh
-rw-r--r--    1 januszoles  staff   557 Dec 16 09:19 authorized_keys
-rw-r--r--    1 januszoles  staff   557 Dec 16 09:14 id_rsa_j13.pub
-rw-r--r--    1 januszoles  staff  1692 Dec 16 00:03 known_hosts
```
```bash
 ➜ cat ~/.ssh/authorized_keys    # check file                                
ssh-rsa A####...####= J13
```
```bash
➜ exit
Connection to 192.168.0.94 closed.
```
#### On iPad 
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
iPad: ssh-add /root/.ssh/id_rsa_j13
Identity added: /root/.ssh/id_rsa_j13 (J13)
```
```bash
iPad: ssh-add /root/.ssh/id_rsa
Identity added: /root/.ssh/id_rsa (root@iPad)
```
```bash
iPad: ssh-add -L
ssh-rsa A#####...####= J13
ssh-rsa A#####...####= root@iPad
```
Now I can login to Mac without password. 

## Create host config file to simplify login

> NOTE: `~/.ssh/config`  DOES NOT exist by default.

```bash
iPad: cat << EOF > /root/.ssh/config
Host j13
    Hostname 192.168.0.94
    Port 22
    User januszoles
EOF
```

Now I can login to my mac by typing:
```bash
ssh j13
```

# TODO
ssh git@github.com:januszoles/ish.git
eval `ssh-agent -s`
eval "$(ssh-agent -s)"
ssh-add -K id_rsa
```

