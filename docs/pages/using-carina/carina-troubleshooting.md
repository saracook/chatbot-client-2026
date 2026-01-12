---
title: "Carina Troubleshooting"
permalink: /troubleshooting
#folder: "using-carina"
#seealso: true
toc: true
---

High Performance Computing is futuristic and exciting...until it isn't. We are collecting common problems and pitfalls here to get you back up and running quickly.

## Connection & Startup Issues

It's frustrating when you can't connect! Here are the first things to check:


### Are you on the Full-Tunnel Stanford VPN?

This is a common issue! Confirm that you are connected to the [Stanford VPN](https://uit.stanford.edu/service/vpn) using the full tunnel. 

### Do you have space in your $HOME?

{% include image.html file="/assets/images/home-full.png" alt="A cat who is too big for the box it is in demonstrates the danger of a full $HOME" class="float-end ms-4" %}

**Running out of disk space will disrupt your work.** 

A lack of free disk space can cause Carina OnDemand and its apps to fail to connect, freeze up, or otherwise behave oddly. 

The error messages may not tell you that disk space is the issue, but it is the most likely cause.

The good news is, you can solve the problem on your own. Your account will still allow you to [connect via SSH](/connect) when you are over your disk quota. 

Connect via SSH, then check your disk usage. It is safe to do this on a login node.

The command to check your usage is: `**du -hs $HOME**`

Your $HOME quota is 25GB, and you should keep a few GB free for your applications to use.

If you are over your quota, move or delete files via the command line in your terminal to free up space. You should be able to access Carina OnDemand once space is available.

{% include support-callout.html %}
