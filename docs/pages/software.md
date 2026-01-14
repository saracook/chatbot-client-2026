---
title: "Software on Carina"
permalink: /software
folder: "using-carina"
seealso: true
toc: true
---

### anaconda3/2025.06

*   **Summary:** Anaconda is a popular, open-source distribution of the Python and R programming languages for scientific computing and data science. It simplifies package management and deployment by including the `conda` package manager and over 250 pre-installed scientific packages (like NumPy, Pandas, and SciPy). Its primary feature is the ability to create isolated, reproducible environments.

*   **Command Line Examples:**
    ```bash
    # Load the anaconda module (in a shared environment)
    module load anaconda3/2025.06

    # Create a new isolated environment named 'my-project' with a specific Python version
    conda create --name my-project python=3.11 pandas

    # Activate the environment to use its packages
    conda activate my-project

    # Run a Python script using the environment's interpreter
    python run_analysis.py

    # Deactivate the environment when finished
    conda deactivate
    ```

---

### matlab/r2025b

*   **Summary:** MATLAB (Matrix Laboratory) is a high-performance language and interactive environment for numerical computation, visualization, and programming. It is widely used in engineering, science, and finance for tasks like matrix manipulation, algorithm development, data analysis, and creating models. It is a commercial product known for its extensive set of specialized "toolboxes."

*   **Command Line Examples:**
    ```bash
    # Load the MATLAB module
    module load matlab/r2025b

    # Start the MATLAB graphical desktop environment
    matlab

    # Run a MATLAB script ('myscript.m') in non-graphical "batch" mode
    # -nodisplay: Do not start the Java desktop
    # -r: Run the specified MATLAB command and then exit
    matlab -nodisplay -r "run('myscript.m'); exit;"

    # Run a script and pipe the output to a log file
    matlab -nodisplay -batch "run('myscript.m')" > output.log
    ```

---

### micromamba/2.3.3

*   **Summary:** Micromamba is a fast, lightweight, C++ reimplementation of the `conda` package manager. It provides the same core functionality for creating environments and installing packages but is significantly faster and has a much smaller footprint. It is ideal for CI/CD pipelines, automated scripts, and users who need a nimble alternative to the full Anaconda distribution.

*   **Command Line Examples:**
    ```bash
    # Load the micromamba module
    module load micromamba/2.3.3

    # Create a new environment named 'fast-env' from the popular 'conda-forge' channel
    micromamba create --name fast-env -c conda-forge numpy scipy

    # Activate the new environment
    micromamba activate fast-env

    # Install an additional package
    micromamba install matplotlib

    # List packages in the current environment
    micromamba list
    ```

---

### r/4.5.1

*   **Summary:** R is a free, open-source programming language and software environment for statistical computing and graphics. It is a dominant tool in academia and data science for statistical analysis, data visualization, and machine learning. R has a vast ecosystem of user-contributed packages available through the Comprehensive R Archive Network (CRAN).

*   **Command Line Examples:**
    ```bash
    # Load the R module
    module load r/4.5.1

    # Start the R interactive console
    R

    # Run an R script ('analysis.R') non-interactively from the command line
    Rscript analysis.R

    # Run a script and save the output and messages to a log file
    Rscript analysis.R > analysis.log 2>&1
    ```

---

### rclone/1.71.2

*   **Summary:** Rclone is a powerful command-line program to manage files on cloud storage. Often called "The Swiss army knife for cloud storage," it supports over 40 backends, including Google Drive, Amazon S3, Dropbox, and OneDrive. It is used for syncing, copying, moving, and listing files between a local machine and remote cloud services.

*   **Command Line Examples:**
    ```bash
    # Load the rclone module
    module load rclone/1.71.2

    # Run the interactive configuration to set up a new remote (e.g., Google Drive)
    rclone config

    # List the contents of a directory on a configured remote named 'my-gdrive'
    rclone ls my-gdrive:research_data

    # Copy a local directory to the remote
    rclone copy /path/to/local/project my-gdrive:backups/project

    # Sync a local directory to a remote (makes destination identical to source)
    rclone sync /path/to/local/project my-gdrive:backups/project-sync
    ```

---

### sas/9.4

*   **Summary:** SAS (Statistical Analysis System) is a commercial software suite used for advanced analytics, business intelligence, data management, and predictive analytics. It has its own programming language (SAS language) and is a standard in industries like pharmaceuticals, finance, and insurance for clinical trial analysis, risk management, and large-scale data processing.

*   **Command Line Examples:**
    ```bash
    # Load the SAS module
    module load sas/9.4

    # Run a SAS program ('my_job.sas') in batch mode
    # -nodms: Run in non-interactive "Display Manager System" mode
    # -log: Specifies the file to write the execution log to
    # -print: Specifies the file to write procedure output to
    sas my_job.sas -nodms -log my_job.log -print my_job.lst

    # Start the interactive SAS environment (if configured on the system)
    sas
    ```
