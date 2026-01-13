---
title: "Medicine Box: Working with Files"
permalink: /integrations/medicine-box-files
toc: true
---

This page covers some of the quirks of interacting with files on Medicine Box from inside Carina.  It assumes that you have set up your connection using [the setup tutorial](medicine-box-setup.html).

To start, [connect to Carina via ssh](/connect-carina.html) and load `rclone`.

`module load rclone`

## Looking around Medicine Box from Carina

### listremotes

To see the remote resources you have configured, use the `listremotes` command.

`rclone listremotes`

{% include image.html class="figure my-4 p-3 border border-light-subtle" file="/assets/images/rclone-remotes.png" alt="rclone listremotes command" %}

This shows the remote resource MedBox, which was created [in this tutorial](medicine-box-setup.html).

### lsjson and ls

First, let’s see what rclone can see on Box by asking it to list the remote resource in JSON format. The advantage of the JSON output is that it will call out the path.

`rclone lsjson [remote resource]:`

{% include image.html class="figure my-4 p-3 border border-light-subtle" file="/assets/images/rclone-box-cli-1.png" alt="A terminal window's output, showing the results of the steps in the text" %}

{% include important.html content="Most Box paths include spaces and must be enclosed in quotation marks when used in commands."%}



This is the Internet, so my test folder is called Pictures of Cats. Choose or create a folder in your own Box for the next step.

{% include image.html class="figure my-4 p-3 border border-light-subtle" file="/assets/images/rclone-pictures-of-cats.png" alt="Shows a listing of files on Box. They are all pics of a cat named Robyn, who is orange and very silly" %}

The path to this folder is going to be MedBox:"Jane Stanford's Files/Pictures of Cats" so if we do a simple list command we will see the folder contents:

`rclone ls [path]`

{% include image.html class="figure my-4 p-3 border border-light-subtle" file="/assets/images/rclone-box-cli-2.png" alt="A terminal window's output, showing the results of the steps in the text" %}

If you can list Box files from Carina, your setup is valid and you can move on to moving files around.

## Copying Files with `rclone copy`

The `rclone copy` command is powerful, with a robust set of optional flags. The [official documentation page](https://rclone.org/commands/rclone_copy/index.html) is well worth reviewing.

Let's look at how we can use `rclone` to copy files between Carina and Medicine Box. We will work on the same files as the example above.

The basic form of the copy command is `rclone copy [options] source destination`

### After the initial copy, `rclone copy` only copies new files

`rclone copy`is aware of the files already at the destination, and will not copy a file if an identical file already exists there. If I run the `rclone copy` command twice, nothing will happen the second time.

As an experiment, I changed the file robyn-bunny-hat.png by resizing it and adding a caption, then uploaded it to Medicine Box in place of the original.

{% include image.html max-width=200 class="figure my-4 p-3 border border-light-subtle" file="/assets/images/robyn-bunny-hat.png" alt="A cat named Robyn, who is orange and very silly, wearing a bunny hat with a look of pure hatred on his face. The caption reads, 'I will have my revenge'" %}


This time, when I run the command again, just the updated file is copied.

{% include image.html class="figure my-4 p-3 border border-light-subtle" file="/assets/images/rclone-copy-replace.png" alt="A terminal window's output, showing the results of the steps in the text" %}

If you copy a new version of a file from Carina to Medicine Box, it will be versioned, so old versions are accessible.

{% include image.html class="figure my-4 p-3 border border-light-subtle" file="/assets/images/rclone-copy-box-version.png" alt="Box UX showing a versioned file" %}

If you copy a new version of a file from Medicine Box to Carina, the old file will be over-written.

### options: dry run, verbose, progress, and interactive

These examples show copying the files in the Pictures of Cats directory on Medicine Box into a directory called cats on Carina.

#### dry run

-n, --dry-run is a way to preview the changes that will be made by running `rclone copy`.  The changes will not be made until the dry run option is removed. Taking a few extra minutes to confirm that you have your paths correct is a smart move.
{% include image.html class="figure my-4 p-3 border border-light-subtle" file="/assets/images/rclone-copy-dry-run.png" alt="A terminal window's output, showing the results of the steps in the text" %}

#### verbose

-v, --verbose will give you more information about the transfer's progress, and can be helpful when doing a high-stakes copy.
{% include image.html class="figure my-4 p-3 border border-light-subtle" file="/assets/images/rclone-copy-verbose.png" alt="A terminal window's output, showing the results of the steps in the text" %}

#### progress

-P, --progress will show real-time upload progress in your terminal

#### interactive

-i, --interactive allows you to approve each file transferred; this is more time-consuming but can be useful when you do not want to copy everything in a directory.
{% include image.html class="figure my-4 p-3 border border-light-subtle" file="/assets/images/rclone-copy-interactive.png" alt="A terminal window's output, showing the results of the steps in the text" %}

### Success!

Here are the files in /cats on Carina

{% include image.html class="figure my-4 p-3 border border-light-subtle" file="/assets/images/rclone-copy-ls.png" alt="A terminal window's output, showing the results of the steps in the text" %}

We hope this has helped you get started using `rclone`. If you have problems or questions about using `rclone`, email us at [srcc-support@stanford.edu(link sends email)](mailto:srcc-support@stanford.edu)
