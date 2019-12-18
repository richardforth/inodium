# inodium
The inode hunter

# No.1 Tip

First check /var/lib/php/session, if you try to `ls` that directory, the ssh session will probably hang because there are too many files in there, possibly dude to php garbage collection failing. If its not that, then you need "inodium", which is a concept at the moment, you can read all about it here.

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

# Why no code yet?

I'm still working on the logic in Ruby - tha language I originally started the project in, since I have gone so far down that road already, I'll get a finished product in ruby, then refactor it here, in perl.

This readme will get updated with examples and example output once I have a working solution.
