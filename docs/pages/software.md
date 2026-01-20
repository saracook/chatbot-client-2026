---
title: "Software Modules on Carina"
permalink: /software
folder: "using-carina"
seealso: true
toc: true
---

Carina has several software packages available via module load on the command line. To see a complete list of the available modules, use `ml avail` in a terminal. 

To see which modules are currently loaded, use 'ml list'.

## Environment & Package Management Utilities

You can't install software on Carina, but you can create a Conda environment on Carina where you have the power to install the exact versions of every package your project requires. The benefits of using Conda include: 

* The environment can run anywhere without touching the underlying system
* Anyone can spin up an exact copy of the environment from a simple requirements file
* Projects are organized and isolated

Conda can be considered the underlying technology, but there are different snake-themed wrappers for it. We offer two that are especially good for HPC systems, Anaconda and Micromamba. Most projects will use one or the other to maintain their environment and packages. 

### Anaconda

This may be the only module you need, because Anaconda lets you install Python and scientific libraries in your own user space. Channels like [conda-forge](https://conda-forge.org/) have optimized versions of libraries and applications ready to be included in your environment.

[Anaconda Documentation](https://www.anaconda.com/docs/getting-started/main)

**Command Line Examples:**

Load the Anaconda module using module load/ml

`module load anaconda3` or `ml anaconda3`

Create a new isolated environment named 'my-project' with a specific Python version

`conda create --name my-project python=3.11 pandas`

Activate the environment to use its packages

`conda activate my-project`

Run a Python script using the environment's interpreter

`python run_analysis.py`

List packages in the current environment

`conda list`

Deactivate the environment when finished

`conda deactivate`

### Micromamba

Micromamba is a fast, lightweight, C++ reimplementation of the `conda` package manager. It provides the same core functionality for creating environments and installing packages but is significantly faster and has a much smaller footprint. 

[Micromamba documentation](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html)

**Command Line Examples:**

Load the Micromamba module using module load/ml

`module load micromamba` or `ml micromamba`

Create a new environment named 'my-env' from the popular [conda-forge](https://conda-forge.org/) channel

`micromamba create --name my-env -c conda-forge numpy scipy`

Activate the new environment

`micromamba activate my-env`

Install an additional package

`micromamba install matplotlib`

List packages in the current environment

`micromamba list`

Deactivate environment

`micromamba deactivate`

## Software for Computation and Analysis

### MATLAB

MATLAB (Matrix Laboratory) is a high-performance language and interactive environment for numerical computation, visualization, and programming. It is widely used in engineering, science, and finance for tasks like matrix manipulation, algorithm development, data analysis, and creating models. It is a commercial product known for its extensive set of specialized "toolboxes."

MATLAB is also available via [Carina OnDemand](/ood-toolbox#server-based-apps).

[MATLAB documentation](https://www.mathworks.com/help/matlab/index.html)

**Command Line Examples:**

Load the MATLAB module with module load/ml

`module load matlab` or `ml matlab`

Run a script and pipe the output to a log file

`matlab -nodisplay -batch "run('myscript.m')" > output.log`

Run a MATLAB script ('myscript.m') in non-graphical "batch" mode 

`matlab -nodisplay -r "run('myscript.m'); exit;"`

<div class="text-body-secondary fst-italic ps-4 mb-4">-nodisplay: Do not start the Java desktop<br />
 -r: Run the specified MATLAB command and then exit</div>

### R

R is a free, open-source programming language and software environment for statistical computing and graphics. It is a dominant tool in academia and data science for statistical analysis, data visualization, and machine learning. 

R Studio is also available via [Carina OnDemand](/ood-toolbox#server-based-apps).

[R documentation](https://cran.r-project.org/)

**Command Line Examples:**

Load the R module with module load

`module load r` or `ml R` (note the capital R)

Start the R interactive console

`R`

Run an R script ('analysis.R') non-interactively from the command line

`Rscript analysis.R`

Run a script and save the output and messages to a log file

`Rscript analysis.R > analysis.log 2>&1`

### SAS

SAS (Statistical Analysis System) is a commercial software suite used for advanced analytics, business intelligence, data management, and predictive analytics. 

SAS is also available on the [Carina Desktop](/ood-toolbox#carina-desktop).

[SAS documentation](https://support.sas.com/en/documentation.html)

**Command Line Examples:**

Load the SAS module with module load/ml

`module load sas` or `ml sas`

Run a SAS program ('my_job.sas') in batch mode

`sas my_job.sas -nodms -log my_job.log -print my_job.lst`

<div class="text-body-secondary fst-italic ps-4 mb-4">
-nodms: run in non-interactive "Display Manager System" mode<br />
-log: specifies the file to write the execution log to<br />
-print: specifies the file to write procedure output to
</div>

## Copy Utility

### rclone

rclone is a powerful command-line program to manage files on cloud storage. It supports over 40 backends, including Google Drive, Amazon S3, Dropbox, and OneDrive. 

[Tutorial for connecting Carina and Medicine Box](/medicine-box-setup.html)

[rclone documentation](https://rclone.org/docs/)

**Command Line Examples:**


Load the rclone with module load/ml

`module load rclone` or `ml rclone`

Run the interactive configuration to set up a new remote (e.g., Google Drive)

`rclone config`

List the contents of a directory on a configured remote named 'my-gdrive'

`rclone ls my-gdrive:research_data`

Copy a local directory to the remote

`rclone copy /path/to/local/project my-gdrive:backups/project`

Sync a local directory to a remote (makes destination identical to source)

`rclone sync /path/to/local/project my-gdrive:backups/project-sync`
