# inodium
The inode hunter

# ruby example

This was tested on Linux Subsystem for windows, so of cource C drive id mounted automatically as /mnt/c, as youd expect it come out on top. Usung file globbing this speeded the process up from hours, to just under 2 minutes.

```
$ sudo ruby inodium.rb /

Top 20 Directories in / for inodes
==================================

Scan started at 2019-12-18 22:41:52 +0000.
Scan completed at 2019-12-18 22:43:11 +0000.

760141                         : /mnt
31587                          : /usr
3113                           : /var
1407                           : /etc
912                            : /lib
663                            : /proc
224                            : /sbin
214                            : /dev
190                            : /sys
175                            : /bin
25                             : /home
14                             : /run
8                              : /root
5                              : /lib64
4                              : /tmp
4                              : /srv
4                              : /snap
4                              : /opt
4                              : /media
4                              : /boot



Done.
```

as it runs so fast, its's trivial to just re-run it on any directory youre interested in digging deeper into!


# No.1 Tip

First check `/var/lib/php/session`, if you try to `ls` that directory, the ssh session will probably hang because there are too many files in there, possibly due to php garbage collection failing. If its not that, then you need "inodium", which is a concept at the moment, you can read all about it here.

# About

This repo will eventually contain the perl code for an inode hunting script use case is for volumes with 100% inode usage, syntax will probably be something like:

```bash
# curl someurl/inodium.pl | perl - /
```

Where the script will need to be "curl and perl" -able due to the fact that with 100% of inodes used, you may not be able to write any actual files to disk.

Originally written in ruby (still developing the logic in that), I realised it wasnt such a good idea to write it in ruby, because ruby often isnt installed by default, requiring a "yum install ruby". I decided not to use any gems to keep it core ruby and lightweight, but even then, on a system with 100% inodes, yum install was'nt going to work, and ruby was not likely to run.

The conclusion is that perl would be a better language to refactor it to, since perl is ubiquitous and amlost guarranteed to be presentm and this is a holding place for that.

# What's with the name?

Well, having a system with plenty of free space but with little or no inodes remaining, its like having "diarhhoea of the files", and when we get the D&V we take a popular medicine to stem that flow, but as I look for inodes, I merged the two words, and come up with "Inodium".

# The issue with ruby

Don't get me wrong, I absolutely adore Ruby Programming, and it was a real pleasure to write this, but as I mentioned, the ruby language interpreter isnt installed by default on many systems, and so, now Ive created my masterpiece, i need to refactor it to work with native interpreters such as perl or python. per is fairly ubuquitous and less peron to wobblies unlike python which differs from distro to distro (in fact perl was a strong choice for apachebuddy.pl too which is why it is able to run on multiple distros.)

# How exactly will it work?

See the example code above, and also have a play with the ruby version, which is now fully working! Its not really for production use due to the requirement to install ruby first, which in a low-or-no inode situation, you may not have that luxury. Curl and perl works well there. Technically you could "curl and ruby"....but you;d need ruby first, which is a bummer.
