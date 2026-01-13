---
title: "Clone from GitHub"
permalink: /clone-github

toc: true
---

## Main navigation

Carina does not allow SSH use with GitHub. You must use HTTPS. The URL can be found on the repo's GitHub page, and it is used like this:

`git clone https://github.com/your-repo/your-repo.git`

## Cloning A Private Repo

If it is a private repo that requires you to sign in, you must set up a [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens.html) on GitHub, scoped to repo as shown below.

You will use this token instead of a password when accessing the private repo through the command line.  The username/password pair is your GitHub username and the personal access token.

`carina:~$ git clone https://github.com/your-repo.git``Cloning into 'your-repo'...``Username for 'https://github.com':`*Type your GitHub username, not your SUnetID*`Password for 'https://<you>@github.com':`*Paste the personal access token*`remote: Enumerating objects: etc etc`
