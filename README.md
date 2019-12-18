# inodium
The inode hunter

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

# Why no code yet?

I'm still working on the logic in Ruby - tha language I originally started the project in, since I have gone so far down that road already, I'll get a finished product in ruby, then refactor it here, in perl.

This readme will get updated with examples and example output once I have a working solution.

# How exactly will it work?

So, to give you an example, lest say you have 2 million inodes on a root partition, and 2 million used. 0 Free.

Unles you know to look in `/var/lib/php/session` FIRST, then hunting inodes is like try to get a picture of Nessie, or the Swasquatch, its not really going to happen, unles you really know your system. Mostly this taks falls to System Administrators like me who dont know the customers system and have to figure it out as we go along.

I'll use the `/var/lib/php/session` folder as a "root of all our problems" directory in this example, but we have to assume we dont know that yet.

So, how I propose it will work is like this:

1. Initial Execution

```bash
# curl someurl/inodium.pl | perl - /
```

What youre seeing here is a classic "curl & perl" operation, grabbing a raw perl script from HTTP/S and then executing it immediately in memory, rather than saving it to disk (handy if we have no inodes).

The dash (-) after per tells perl that the NEXT argument, is NOT for perl, but forthe SCRIPT we are execuing in perl, otherwise you get an error about perl not knowing what to do with /.

So in our script, / becomes ARGV[0], the first argument.

2. My plan is to take that argument, make it the root directory for our scan - call it "scanroot"

3. Get a listing of all Subdirectories in the root location set at ARGV[0]

3a. Create a Circular Buffer to act as a "top 20"

4. Loop through each folder, counting files in the folder and all subfolders, add them to the top 20 only if the number of inodes in that folder is greater than the "highest" in the top 20, thus dropping the lowest if the buffer is full each time. If the buffer isnt full the items are added to the buffer anyway if they are higher than the highest value, but nothign us dropped unless the buffer is full, thus maintaining a "rolling top 20"

4a. (optional) If one of the folders causes a long delay, re-set the root folder to that folder, and repeat 1 - 4

   - lets say the first run was /
   - it suffers a long delay on /var, so it times itself out and resets ARGV[0] "scanroot" variable to /var
     - it suffers a long delay on /var/lib, so again, it times itself out and resets ARGV[0] "scanroot" variable to /var/lib
     - it suffers a long delay on /var/lib/php, so again, it times itself out and resets ARGV[0] "scanroot"variable to /var/lib/php
     - it suffers a long delay on /var/lib/php/session, so again, it times itself out and resets ARGV[0] "scanroot"variable to /var/lib/php/session
      
      NOTE: 4a is currently flawed though, because we are "self-limiting" to one path (otherwise known as "going down a rabit hole" and missing the bigger picture)

4b.  Continue to rip through the remaining folders in the original "scanroot" and updating the circular buffer as needed

5. Print a report of the top 20 inode locations in the original "scanroot".
