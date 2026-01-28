---
title: "Data Transfer and Management"
permalink: /data-management
folder: "using-carina"
seealso: true
toc: true
---

Almost every researcher's job involves moving data from one place to another at some point.

Carina's dedicated data transfer node, `c2-transfer.carina.stanford.edu`, is the fast, secure gateway for moving your research data into and out of the Carina environment.

This node is only for data transfer. Your available Carina filesystems ($HOME, /project) will be mounted and accessible.

{% include tip.html type="success" title="Help is Available" icon="fa-dolly" content="If you are moving a large amount of data, consider making an appointment to discuss your plan with our experts at [Office Hours](/office-hours), or send an email to [srcc-support@stanford.edu](mailto:srcc-support@stanford.edu). Let us help you make the data transfer as fast and easy as possible. " %}

## The Easy Way: SFTP Client

An SFTP client is an interactive app that lets you connect to a remote filesystem

A variety of graphical SFTP clients are available for different OSes:

<ul class="list-unstyled"> 
<li><i class="fa-brands fa-windows"></i> <a href="//winscp.net/eng/docs/introduction">WinSCP</a></li>
<li><i class="fa-brands fa-windows"></i> <a href="//uit.stanford.edu/software/scrt_sfx">SecureFX</a></li>
<li><i class="fa-brands fa-apple"></i> <a href="//fetchsoftworks.com/">Fetch</a></li>
<li><i class="fa-brands fa-apple"></i> <a href="//cyberduck.io/">CyberDuck</a></li>
</ul> 

{% include image.html file="/assets/images/fetch-dtn.png" alt="Fetch setup"  class="mb-5 p-4 border border-dark-subtle" caption="Connecting to the DTN with Fetch" %}  


When setting up your connection to the Carina DTN in the above programs, use the following information:

Hostname: `c2-transfer.carina.stanford.edu`<br>
Port:     `22`<br>
Username: `SUnet ID`<br>
Password: `SUnet ID password`<br>

## SFTP via Command Line

If you are sure you don't want to use an SFTP client, your next best option is SFTP in a terminal via the command line. [SFTP documentation](https://docs.oracle.com/cd/E36784_01/html/E36870/sftp-1.html)

Open a terminal on your local machine, which we will call Laptop. 

Connect with `sftp <sunetid>@c2-transfer.carina.stanford.edu` and your SUnet ID password. 

{% include image.html file="/assets/images/sftp-connect.png" alt="terminal sftp connection"  class="mb-5 p-4 border border-dark-subtle w-auto" %} 

That sftp prompt means we are in! Our data for this example is a folder called pictures-of-cats. 

### Local & Remote

*   **Remote commands** (on Carina) are used directly: `ls`, `cd $HOME`, `pwd`
*   **Local commands** (on Laptop) are prefixed with **l** (lower-case L): `lls`, `lcd $HOME`, `lpwd`

The screenshots below have been annotated to show where the commands happen. This shows the `lls -l` command being run (on Laptop, because it's `lls` not `ls`), showing the files about to be uploaded to Carina.

{% include image.html file="/assets/images/sftp-ls.png" alt="terminal sftp list"  class="mb-5 p-4 border border-dark-subtle w-auto" %} 

### put
Let's copy that to a folder in $HOME on Carina. It's a directory, so we'll need the -r flag for recursive. The terminal will show the progress of each file.

`put -r pictures-of-cats`

{% include image.html file="/assets/images/sftp-put-r.png" alt="terminal sftp put"  class="mb-5 p-4 border border-dark-subtle w-auto" %} 

That looks great, except now all the files have the same datestamp.

There's a fix for that! We need to add the `-P` flag, which keeps the original files' full permissions and access time.

`put -r -P pictures-of-cats`

{% include image.html file="/assets/images/sftp-put-r.png" alt="terminal sftp put with -P flag"  class="mb-5 p-4 border border-dark-subtle w-auto" %} 

### get & mget

{% include image.html file="/assets/images/internet-cats.png" alt="Cats make things better"  class="mb-5 p-4 border border-dark-subtle w-75" caption="picture of a cat" %}

Using the same connection as the `put` commands, it is possible to pull files down from the remote (Carina) to the local (Laptop) environment using the `get` and `mget` commands.

{% include image.html file="/assets/images/sftp-get-ls.png" alt="terminal file listing"  class="mb-5 p-4 border border-dark-subtle w-auto" %}

I have a folder on Carina called more-cats, and it is full of good cat content that I want to have on Laptop. I've created a directory, cat-downloads, on Laptop to receive the files.

{% include image.html file="/assets/images/sftp-get-ls.png" alt="terminal file listing"  class="mb-5 p-4 border border-dark-subtle w-auto" %}

'get' is a blunt instrument; it can pick one file at a time. That is not such a bad thing if your data is in a single, neat tarball; it's wildly inefficient for moving many files.

This is what moving one file with `get` looks like. 

`get more-cats/kitty-smol.png`

{% include image.html file="/assets/images/sftp-get.png" alt="terminal file listing"  class="mb-5 p-4 border border-dark-subtle w-auto" %}

The command to get many files, either by direct path or wildcard selectors, is `mget`. The m stands for multiple.

This example uses wildcard matching to move all the .png files.

`mget more-cats/*.png`

{% include image.html file="/assets/images/sftp-mget-wildcard.png" alt="terminal file listing"  class="mb-5 p-4 border border-dark-subtle w-auto" %}

Oh, look, we still have the problem of the datestamps being overwritten, just like when we used the `put` command. 

Fortunately, the solution is the same: the `-P` flag. Let's try copying a directory recursively with the `-r` flag in addition to the `-P` flag, just to keep things interesting. We also could have used `-P` with the wildcard `mget` above. 

`mget -r -P more-cats`

{% include image.html file="/assets/images/sftp-mget-p.png" alt="terminal file listing"  class="mb-5 p-4 border border-dark-subtle w-auto" %}

File permissions are individually duplicated on the copied files. File permissions can be manipulated from within the `sftp` shell, consult the [SFTP documentation](https://docs.oracle.com/cd/E36784_01/html/E36870/sftp-1.html) for more information.

## Using Carina with Medicine Box & rclone

After a bit of setup, file transfers between Carina and Medicine Box are easy.

[setup tutorial](/medicine-box-setup.html) 

[copying files tutorial](/medicine-box-files.html)
