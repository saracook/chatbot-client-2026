---
title: "Using GitHub with Carina"
permalink: /clone-github
seealso: true
folder: using-carina
toc: false
---

Carina does not allow SSH use with GitHub. You must use HTTPS. The URL can be found on the repo's GitHub page, and it is used like this to clone a public repo:

`git clone https://github.com/your-repo/your-repo.git`

### Cloning A Private Repo

Some repos are private and will require you to authenticate yourself. The best way to do this over HTTPS is to set up a Personal Access Token on GitHub, following [their documentation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens). 

Scope: Repo

{% include image.html file="/assets/images/carina-github.png" alt="Making a personal access token on github"  class="mb-5 p-4 border border-dark-subtle" %}  

You will use this token instead of a password when accessing the private repo through the command line.  The username/password pair is your GitHub username and the personal access token.

{% include image.html file="/assets/images/carina-github2.png" alt="Making a personal access token on github"  class="mb-5 p-4 border border-dark-subtle" %}  

<div class="card">
  <div class="card-header">
    Authentication Flow in Terminal
  </div>
  <div class="card-body">
    <p class="card-text fst-italic">git clone https://github.com/your-repo.git</p>
    <p class="card-text mb-0"><code>Username for 'https://github.com':</code></p>
    <p class="card-text fst-italic">Type your GitHub username, not your SUnetID</p>
    <p class="card-text mb-0"><code>Password for 'https://&lt;you&gt;@github.com':</code></p>
    <p class="card-text fst-italic">Paste your personal access token</p>
  </div>
</div>
