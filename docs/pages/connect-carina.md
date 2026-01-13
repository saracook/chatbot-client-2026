---
title: "Connect to Carina"
permalink: /connect
toc: true
---

You can access Carina via ssh or the web interface.

### <span class="badge rounded-pill text-bg-primary">Step 1</span> Connect to the Full-Tunnel Stanford VPN

This is the #1 reason for connection failure! For help with the VPN, consult the excellent [UIT documentation](https://uit.stanford.edu/service/vpn).

### <span class="badge rounded-pill text-bg-primary">Step 2</span> Connect to Carina

Choose a connection method, or use both

#### SSH Connection

`ssh <sunetid>@c2-login.carina.stanford.edu`

This will land you on a login node. You are now logged in, but you do not have any Carina resources to use. The login node won't support the cool things you want to do. For that, you will need SLURM.

***SLURM? What is that?*** [Slurm Docs](/slurm).

#### Carina OnDemand

[Carina OnDemand](https://carina.stanford.edu/) is based on the popular Open OnDemand platform, which is used across many Stanford research systems. 

{% include important.html title="First visit error? " content="If Carina OnDemand gives you an error about a missing home directory the first time you visit, please log in via ssh as described above. This will create the missing directory and allow Carina OnDemand to load." %}

### <span class="badge rounded-pill text-bg-primary">Step 3</span> Find your files

Your $HOME is `/home/users/<sunetid>`. 

Project folders are at `/projects/<PI>/<projectID>/main`.
