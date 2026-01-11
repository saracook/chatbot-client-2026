---
title: "Data Migration"
permalink: /migrate
toc: true
---
You are responsible for migrating any desired files in your personal $HOME directory from Carina 1.0 to Carina 2.0. 

We encourage everyone to do some folder housekeeping before migrating. Your storage quota is the same for both systems.

There is no direct connection between the two systems, so you will need to download your files from Carina 1.0 and upload them to Carina 2.0. We recommend using your secure Stanford laptop as the intermediary. 

## Copy entire $HOME

This is a simple method using sftp. 

Step 1 Get files from Carina 1.0

Connect to Carina 1.0 from your laptop terminal, using `sftp` instead of `ssh`

`sftp <sunetid>@login.carina.stanford.edu`

`get -R /home/<sunetid>/`

The -R flag here tells sftp to include any dotfiles in the directory. 


## Dotfiles

If you are only migrating some files, don't forget to get conf files and directories like .conda, .config, and .bashrc. 

You may have application config files in your $HOME. For example, if you used JupyterLab on Carina 1.0, your settings are saved in the $HOME/.jupyter folder there. 






Step 2 Put files on Carina 2.0
