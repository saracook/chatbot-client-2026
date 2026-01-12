---
title: "Data Migration"
permalink: /migrate
toc: true
customjs: /assets/js/migrate.js
seealso: true
folder: carina-policy
---
You are responsible for migrating any desired files in your personal $HOME directory from Carina 1.0 to Carina 2.0. 

We encourage everyone to do some folder housekeeping before migrating. Your storage quota is the same for both Carinas.

There is no direct connection between the two systems, so you will need to download your files from Carina 1.0 and upload them to Carina 2.0. We recommend using your secure Stanford laptop as the intermediary. 
<div class="border border-dark-subtle p-3 my-5">
<h3>Magic rsync Command Generator</h3>
<p>Enter your information below and click the Generate button to generate copy & paste commands with your information pre-filled</p>


<form id="rsyncForm" class="d-flex flex-row align-items-end flex-wrap">
    <div class="col p-2">
        <label for="sunetid" class="form-label">SUNetID</label>
        <input type="text" class="form-control" id="sunetid" required>
    </div>
    <div class="col p-2">
        <label for="localDirectory" class="form-label">Local Directory</label>
        <input type="text" class="form-control" id="localDirectory" required>
    </div>
    <div class="form-check col p-2">
        <input type="checkbox" class="form-check-input" id="dryRun">
        <label class="form-check-label" for="dryRun">Dry Run</label>
    </div>
    <button type="submit" class="btn btn-primary col">Generate Rsync Commands</button>
</form>
</div>

### <span class="badge rounded-pill text-bg-primary">Step 1</span> Get files from Carina 1.0

We will use rsync in a terminal on the laptop for this. 

First, try the command with the --dry-run flag to check your file paths. 

<div class="border border-dark-subtle p-3 my-5">
    <label for="rsyncCmd" class="form-label">Rsync Command to get $HOME from Carina:</label>
    <div class="input-group mb-3">
    <input type="text" class="form-control form-control-lg m-0" id="rsyncCmd" readonly>
            <button class="btn btn-outline-primary" id="copyBtn" type="button">Copy</button>
    </div>
</div>

### <span class="badge rounded-pill text-bg-primary">Step 2</span> Put files on Carina 2.0

<div class="border border-dark-subtle p-3 my-5">
<label for="rsyncCmd2" class="form-label">Rsync Command to put downloaded $HOME files on Carina 2.0:</label>
<div class="input-group mb-3">

  <input type="text" class="form-control form-control-lg m-0" id="rsyncCmd2" readonly>
        <button class="btn btn-outline-primary" id="copyBtn2" type="button">Copy</button>
</div>
</div>


#### Dotfiles

When you upload your files to Carina 2.0, don't forget to get config files and directories like .conda, .config, and .bashrc. 

You may have application config files in your $HOME. For example, if you used JupyterLab on Carina 1.0, your settings are saved in the $HOME/.jupyter folder there. 
