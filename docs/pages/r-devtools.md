---
title: "Install devtools in R"
permalink: /r-devtools
folder: "using-carina"
seealso: true
toc: true
---

`devtools` is a package that provides R functions to simplify many common tasks. It is commonly used to install packages from GitHub and other sources.

**Important**: Installing `devtools` is memory-intensive and installs many dependencies. 

### Installation Location

By default, packages install to `$HOME/R/x86_64-pc-linux-gnu-library/<R_version>`. This is a **local installation** specific to your Carina environment. If you are prompted to create this Personal Library folder, allow it.

## Choose Your Installation Method

### Method 1: Carina OnDemand (Recommended for most users)

This web-based method is the easiest approach.

1. Start an [RStudio session](https://c2-ondemand.carina.stanford.edu/pun/sys/dashboard/batch_connect/sys/rstudio-server/session_contexts/new)

2. **Choose the Large size** for sufficient memory
{% include image.html file="/assets/images/r-start.png" alt="Launching an RStudio session on Carina" class="mb-5 ms-4 p-4 border border-dark-subtle w-75" %}

{:start="3"}

3. Connect to your session from [My Interactive Sessions](https://c2-ondemand.carina.stanford.edu/pun/sys/dashboard/batch_connect/sessions)

   {% include image.html file="/assets/images/rstudio-card.png" alt="Running RStudio session on Carina" class="mb-5 ms-4 p-4 border border-dark-subtle w-75" %}

{:start="4"}

4. In the RStudio Console, run:

    `install.packages("devtools")`

{% include image.html file="/assets/images/r-ood-started-install.png" alt="RStudio session on Carina"  class="mb-5 ms-4 p-4 border border-dark-subtle w-75" %}

{:start="5"}

5. If prompted, select a CRAN mirror

6. Wait for the installation to complete (this may take several minutes)

### Method 2: Command Line

This method gives you more control over resource allocation.

1. [Connect to Carina](/connect) via SSH

2. Request compute resources via [Slurm's srun command](/slurm#srun) (cannot run on login nodes):

    `srun -p normal -n 1 --cpus-per-task=8 --pty bash`

    This requests one node with 8 CPUs on the [normal partition](/slurm-carina#slurm-queuespartitions). 

{:start="3"}

3. When you are on a computing node, load the R module. Note that R is an exception to the "all module names are lowercase" rule, and must be loaded with an uppercase R.

    Load the default version:

    `module load R` or `ml R` (module load and ml are interchangeable)

    Load a different version:

    `ml R/4.4.3` 

4. Start R:

   `R`

5. Install devtools:

   `install.packages("devtools")`

    If prompted, choose a CRAN mirror and approve creating the Personal Library

{% include image.html file="/assets/images/r-cli-mirror.png" alt="Installing devtools via command line" class="mb-5 ms-4 p-4 border border-dark-subtle w-75" %}




### Verify Installation

After installation completes, load the library to verify:

`library(devtools)`

If successful, you should see no errors. You can also check the version:

`packageVersion("devtools")`


### Available R Versions

These R versions are available in Carina OnDemand and via `module load`:

* R/4.3.3
* R/4.4.3
* R/4.5.1 (current default)

To use a specific version in OnDemand, select it in the session launch form. For command line, specify the version when loading the module, for example `ml R/4.4.3`.

### Next Steps

With `devtools` installed, you can:
- Install packages from GitHub: `devtools::install_github("username/repo")`
- Install from local sources
- Access development tools for creating your own packages

See the [devtools documentation](https://devtools.r-lib.org/) for full functionality.
