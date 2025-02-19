# ARC Tutorial for Python Users

# 0. Introduction to ARC 

The Advanced Research Computing (ARC) service provides access to High Performance Computing resources, support, and advice to researchers within the University of Oxford. There is an extensive documentation on how to use ARC : 

* [ARC User Guide](https://arc-user-guide.readthedocs.io/en/latest/)
* [ARC Software Guide](https://arc-user-guide.readthedocs.io/en/latest/)
* [ARC Module List](https://arc-module-list.readthedocs.io/en/latest/)

And some trainings are regularly organized : [Training](https://www.arc.ox.ac.uk/training). **The aim of this tutorials is to provide a short document that should help Python users to quickly start using ARC.** The documents cited above are the reference documents, with all the details and regular update. The tutorial is written from the perspective of a Mac user, Linux users should be able to follow the same instructions but Windows users should refer to the official documentation.

At the centre of the ARC service are two high performance compute clusters - arc and htc.

* **arc** is designed for multi-node parallel computation
* **htc** is designed for high-thoughput operation (lower core count jobs).

htc is also a more heterogeneous system offering different types of resources, such as GPU computing and high memory systems; nodes on arc are uniform. Users get access to both both clusters automatically as part of the process of obtaining an account with ARC, and can use either or both.

For more detailed information on the hardware specifications of these clusters, see the [ARC User guide](https://arc-user-guide.readthedocs.io/en/latest/arc-systems.html.)

The ARC workflow is described in the following scheme : 

![image info](./workflow.png)

When you log into ARC you log into a **Login Node**. From there you : 
* Copy files to/from ARC (see [section 3](#3-transferring-files)). These files are stored in some directory on the **Shared disk**, only you can access your data but the amount of storage available is shared.
* Prepare and submit jobs (see [section 4](#4-running-jobs-on-arc)) and access the results after job(s) are completed

The **Management Nodes** manage the job queue and decide when and where to start a job. Note that only the Management Nodes have access to the **Compute nodes**, in particular, you should never run code on your Login node. 


Using ARC requires a bit of set up the first time you use it. In order to keep this tutorial as short as possible the setup part is presented in [Appendix](#appendix--how-to-set-up-arc). Once everything is set up, everything you need to know is explained in the following four sections. 

1. [Logging in to ARC](#1-logging-in-to-arc)
2. [ARC overview](#2-arc-overview)
3. [Transferring Files](#3-transferring-files)
4. [Running jobs on ARC](#4-running-jobs-on-arc)


## 1. Logging in to ARC

Before you start, make sure you have access to ARC (see [Appendix](#a-accessing-the-arc-cluster)).

To access the ARC cluster from a Mac we will use ssh. This will only works if you are on the University of Oxford network. If you are not on the University network, you should use the [University VPN](https://help.it.ox.ac.uk/vpn#tab-4157281). 

To connect to the ARC cluster (large parallel jobs):
```bash
ssh abcd1234@arc-login.arc.ox.ac.uk
```
To connect to the HTC cluster (single-core to single-node jobs): 

```bash
ssh abcd1234@htc-login.arc.ox.ac.uk
```

Where `abcd1234` is your actual ARC username, which should be your Oxford SSO. If you have not set up an SSH key (see [Appendix](#a3-ssh-key-setup-optional)), you will be prompted to enter your password.

Upon logging in, you will be placed in your ARC `$HOME` directory.

## 2 ARC overview 

### 2.0 Basic Linux command

ARC operates on Linux. If you are unfamiliar with Linux, don’t worry—you only need basic knowledge. Here are some essential Linux commands that will help you navigate and manage files on the ARC cluster:

* `cd`: Changes the current directory. Use `cd /path/to/directory` to move into a directory and `cd ..` to go up one level. Using `cd` without arguments returns to your `$HOME` directory.
* `ls`: Lists files and directories in the current location. Options include `ls -l` for detailed information, `ls -a` to show hidden files, and `ls -lh` for human-readable file sizes.
* `rm`: Deletes files. Use `rm filename` to remove a file. Be careful, as deletion is permanent.
* `rm -r`: Recursively deletes directories and their contents. Use `rm -r directory_name` to delete a directory.
* `cat`: Displays the content of a file. Use `cat filename` to view a file’s content.

If you want to know more about Linux, plenty of resources are available online. The ARC teams recommend this [tutorial](https://ryanstutorials.net/linuxtutorial/).


### 2.1 `$HOME` directory

If you ever need to go back to your `$HOME`directory, juste type 
```bash
cd $HOME
```
You can create folders in your `$HOME` directory to organise your programs and scripts. Do not run code or compile programs directly in your `$HOME` directory. The correct way to execute code on ARC is by submitting a job (see below). Your `$HOME` directory has a storage limit of 20GB, making it unsuitable for storing large datasets. If you ever want to check how many storage you have left you can type : 

```bash
myquota
```

### 2.2 `$DATA` directory

Another key directory is `$DATA`, which is intended for job outputs and large datasets. To go there type 

```bash
cd $DATA
```
The `$DATA` directory provides 5TB of shared storage for your project. Use it for storing job outputs and large datasets for analysis. To check how many storage you have left, use the same command as before `myquota`.

## 3. Transferring Files

We will frequently need to transfer files to and from ARC. There are several ways to do that, here are the two way I use most of the time :

### 3.1 Using Github 

A convenient way to transfer code files to ARC is via GitHub. If you already have a GitHub repository with your code, you can clone it into your `$HOME` directory and keep it synchronized.

To use GitHub from the command line, you must set up SSH authentication (see [Appendix](#b-setting-up-a-github-repository)). Once SSH is set up, clone repositories using:

```bash
git clone git@github.com:username/repository.git
```

The SSH address can be found on your repository's GitHub page under the 'Code' button. This downloads the repository to your ARC workspace. You can then navigate into the repository using `cd repository`.

Here are some essential Git commands:

* `git pull`: Updates your local repository with the latest changes from GitHub.
* `git commit -m "Your message"`: Saves staged changes with a message.
* `git push`: Uploads committed changes to GitHub.

You will probably only pull from ARC and do all modification of code on your personal computer. Plenty of resources are available online to learn Git and GitHub, see for instance:
* [GitHub Documentation](https://docs.github.com/en/get-started/using-git/about-git)
* [Git Reference](https://git-scm.com/docs)

### 3.2 Using `scp`
While very convenient, GitHub imposes a file size limit (typically 100MB per file), making it unsuitable for transferring large datasets to ARC. To copy big files to ARC, one can use `scp`

```bash
scp local_file.extension abcd1234@arc-login.arc.ox.ac.uk:/path/to/destination/
```

To copy files from ARC:
```bash
scp abcd1234@arc-login.arc.ox.ac.uk:/path/to/file.extension local_destination/
```

If you're not sure of the exact destination path on ARC, log in to ARC, navigate to the desired directory, and run pwd. This command will print the full path to the directory, which you can use with scp

To copy an entire directory (including its contents), use the -`r` (recursive) option. For example: 

```bash
scp -r abcd1234@arc-login.arc.ox.ac.uk:/path/to/directory local_destination/
```

## 4. Running Jobs on ARC

### 4.1 SLURM

ARC is a shared computational resource among all departments of the University of Oxford. Since this involves many users, a resource manager is needed to properly distribute the available computing power. ARC uses [SLURM](https://slurm.schedmd.com/documentation.html) (Simple Linux Utility for Ressource Management). 

Instead of running code directly in the command line as you would on your personal computer, **you must write a SLURM submission script** (written in Bash). This script specifies details such as the job name, estimated runtime, required CPU cores and memory, and the code to execute. Then, SLURM will allocate you job a number and a place in its queue. Your code will run when it reaches the top of the queue. 

Several factors influence job priority in the queue, including submission frequency, job duration, and the requested computational resources. Some research groups can purchase credits to gain higher priority in the queue. You can find more information on the [SLURM Reference Guide](https://arc-user-guide.readthedocs.io/en/latest/slurm-reference.html).

### 4.2 An example of submission script 

Here is an example of a submission script that you can copy and paste and modify for your specific needs, you can also download it [here](https://github.com/ValentinKil/ARCPythonTutorial/blob/main/submision-script.sh), lets go through it: 

```bash
#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=96000
#SBATCH --time=48:00:00
#SBATCH --partition=long
#SBATCH --job-name=my_python_job
#SBATCH --mail-type=ALL
#SBATCH --mail-user=name.surname@college.ox.ac.uk
#SBATCH --account=name_of_the_project

# Store original directory and print useful environment variables
ORIG=$(pwd)
echo "TMPDIR: $TMPDIR"
echo "SCRATCH: $SCRATCH"

# Set up directories
SCRATCH_DIR="$TMPDIR/run_$SLURM_JOB_ID"
mkdir -p "$SCRATCH_DIR"
mkdir -p "$SCRATCH_DIR/output"

DEST="$DATA/run_$SLURM_JOB_ID"
mkdir -p "$DEST"


cd "$SCRATCH_DIR" || exit 1
echo "Current directory: $(pwd)"

# Copy input files and program to scratch directory
SRC_DIR="$ORIG/path/to/code/src"
cp -r "$SRC_DIR" "$SCRATCH_DIR"

# Load Anaconda module
module load Anaconda3

# Create or activate Conda environment
export CONPREFIX=$DATA/envname
source activate "$CONPREFIX" || { echo "Failed to activate Conda environment!"; exit 1; }

# Install required packages
conda install pip
pip install -r "$SCRATCH_DIR/src/requirements.txt" || { echo "Failed to install dependencies!"; exit 1; }

# Print job details
echo "Running on host: $(hostname)"
echo "Scratch directory: $SCRATCH_DIR"
echo "Output directory: $DEST"

# Run Python script
SCRIPT="$ORIG/path/to/code/script.py" 
cp -r "$SCRIPT" "$SCRATCH_DIR"
python script.py --output-dir "$SCRATCH_DIR/output" --data-dir "$DATA/dataset/data.npz" || { echo "Python script execution failed!"; exit 1; }

# Copy output files back to the destination directory
cp -r "$SCRATCH_DIR/output/"* "$DEST" || { echo "Failed to copy output files!"; exit 1; }

# Clean up scratch directory
rm -rf "$SCRATCH_DIR"

echo "Job completed successfully."
```

### 4.3 Breakdown of the submission script : SLURM instruction

The script starts with SLURM directives, which specify the computational resources required for the job.

* **Ask for cores and memory** : 

```bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=96000
```

When requesting ARC cores and memory, it is important to know: Each ARC compute node has 48 cores and 380G RAM, so about 8G RAM per core. So, for one node do not request more than 48 cores, and do not request more memory than 8G times the number of cores.

On HTC you can ask for high memory nodes and GPU, More details are available in the [ARC User Guide](https://arc-user-guide.readthedocs.io/en/latest/job-scheduling.html ).

* **Partitions**
```bash
#SBATCH --time=48:00:00
#SBATCH --partition=long
```
The clusters have the following time-based scheduling partitions available :

* `short`: default run time 1hr, maximum run time 12hrs.
* `medium`: default run time 12hrs, maximum run time 48hrs.
* `long`: default run time 24hrs, no run time limit.
* `devel`: maximum run time 10 minutes - for batch job testing only
* `interactive`: maximum run time 24hrs, for pre/post-processing. 

Jobs in the short and medium partitions have higher scheduling priority than those in the long partition, but they are restricted by their respective maximum run times. Interactive jobs function differently; see the [ARC User Guide](https://arc-user-guide.readthedocs.io/en/latest/job-scheduling.html) for more information

* **Basic information**
```bash
#SBATCH --job-name=my_python_job
#SBATCH --mail-type=ALL
#SBATCH --mail-user=name.surname@college.ox.ac.uk
#SBATCH --account=name_of_the_project
```

These directives provide basic information about the job. The 'mail' directives will trigger an email alert when a job begins, finishes, or fails. 

### 4.4 Breakdown of the submission script : other shell commands

The other shell commands say what to do in job. At the beginning of a job some temporary directory will be created : 
* `$TMPDIR`: local directory accessible only by a compute node.
* `$SCRATCH`: shared file system available to all nodes in a job.

* **Setting up directories**

We start by setting up directories in the local directory `$TMPDIR`. The `$SLURM_JOB_ID` is a unique ID assigned by SLURM to the job.

```bash
# Set up directories
SCRATCH_DIR="$TMPDIR/run_$SLURM_JOB_ID"
mkdir -p "$SCRATCH_DIR"
mkdir -p "$SCRATCH_DIR/output"
```
Then we set up a directory in `$DATA` where we will store our result at the end of the job. 

```bash
DEST="$DATA/run_$SLURM_JOB_ID"
mkdir -p "$DEST"
```
And we move to our working directory :

```bash
cd "$SCRATCH_DIR" || exit 1
echo "Current directory: $(pwd)"
```

Finally, we copy our source code from `$HOME` (or any directory where we start the job) to `$SCRATCH_DIR`.

```bash
SRC_DIR="$ORIG/path/to/code/src"
cp -r "$SRC_DIR" "$SCRATCH_DIR"
```

* **Python environment**

In order to use Python, we will first have to set up a Python environment (see [Appendix](#c-setting-up-a-python-virtual-environment) or the [ARC User Guide](https://arc-software-guide.readthedocs.io/en/latest/python/anaconda.html)). Once this is done we can proceed as follow to set up the environment : 

```bash
# Load Anaconda module
module load Anaconda3

# Create or activate Conda environment
export CONPREFIX=$DATA/envname
source activate "$CONPREFIX" || { echo "Failed to activate Conda environment!"; exit 1; }

# Install required packages
conda install pip
pip install -r "$SCRATCH_DIR/src/requirements.txt" || { echo "Failed to install dependencies!"; exit 1; }
```

The requirements.txt file should contain all the packages required to run your code.You can generate a requirements.txt file by running `pip freeze` from your local environment on your personal computer. 


* **Run your Python script**

You can then proceed to copy your Python script to the working directory and then run it :  

```bash
# Run Python script
SCRIPT="$ORIG/path/to/code/script.py" 
cp -r "$SCRIPT" "$SCRATCH_DIR"
python script.py --output-dir "$SCRATCH_DIR/output" --data-dir "$DATA/dataset/data.npz" || { echo "Python script execution failed!"; exit 1; }
```

Note that your script is running on a temporary directory that has been created at the beginning of the job and will be erased at its end. This means that if you want to save some output it must be done in the `$DATA` directory. Similarly, if you want want to proceed some data, your script needs to seek for them in the `$DATA` directory. That's why we give these two directories as input of the script. On the python side you can provide as follow to get and use this two path :

```python3
# Parse command-line arguments
parser = argparse.ArgumentParser(description="Run ARC Code")
parser.add_argument("--output-dir", type=str, required=True, help="Output directory for results")
parser.add_argument("--data-dir", type=str, required=True, help="Input data directory")
args = parser.parse_args()

# Get the output directory from command-line arguments
output_dir = args.output_dir
data_dir = args.data_dir
```

where we use the library `argparse`


### 4.5 Submit  and manage your script

Once your submission script is written, you can submit it with:

```bash
sbatch job_script.sh
```
You should get a response:

```bash
submitted bash job <JOB_ID>
```
To check the status of all your jobs, type:
```bash
squeue -u abcd1234
```
To cancel a job:
```bash
scancel JOB_ID
```
To see the current output:
```bash
cat slurm-JOB_ID.out
```

-----------------

# Appendix : How to set up ARC

Get back to [Section 0](#0-introduction-to-arc)

## A. Accessing the ARC Cluster

### A.0 Getting an ARC account

To access and use ARC you need to be attached to a project, any academic of the University of Oxford can create a project. Once a project is created you can apply to get an ARC account [here](https://www.arc.ox.ac.uk/arc-user-registration-page). The project manager will have to validate your application, and once this is done you will receive an email with your username and a separated email with a temporary password. 

### A.1 Logging in to ARC for the first time
To access the ARC cluster from a Mac we will use ssh. This will only works if you are on the University of Oxford network. If you are not on the University network, you should use the [University VPN](https://help.it.ox.ac.uk/vpn#tab-4157281). 

To connect to the ARC cluster:
```bash
ssh abcd1234@arc-login.arc.ox.ac.uk
```
Where `abcd1234` is your actual ARC username, which should be your Oxford SSO. When you log in you are on your `$HOME` directory,You are the only one who has access to this directory and you can store up to 20GB into it. The other important directory is $DATA, where 5TB is available to be shared among all project members (for more detail see [Section 2](#2-arc-overview)).

### A.2 Changing your password

The first thing to do is to change your password, for that type 
```bash
passwd
```
You will be prompted to enter your current password, followed by the new password. After entering it twice, your password will be updated.

Get back to [Section 1](#1-logging-in-to-arc)

### A.3 SSH Key Setup (Optional)
To avoid entering your password every time you connect to a remote system via SSH, you can set up SSH key-based authentication. Here’s how you can do it:

1. **Generate an SSH key** (if you don’t have one): 
First, create an SSH key pair by running on you local computer the following command. You can replace "ASecretSentences" with any comment you like  :
```bash
ssh-keygen -t ed25519 -C "ASecretSentences"
```

This will generate a private and public key pair in the default `~/.ssh/ directory`. You can accept the default file location or specify a different one when prompted.

2. **Copy the public key to ARC:** Once the key pair is generated, copy the public key to your ARC home directory using the following command
```bash
ssh-copy-id abcd1234@arc-login.arc.ox.ac.uk
```
This command will prompt you to enter your password. Afterward, your public key will be added to the` ~/.ssh/authorized_keys` file on the remote server, and you’ll be able to log in without entering a password in the future.

3. **Test your setup:** After the public key is copied, you can test the setup by connecting to the remote server :
```bash
ssh abcd1234@arc-login.arc.ox.ac.uk
```
If everything is set up correctly, you should be logged in without needing to enter your password.

Get back to [Section 1](#1-logging-in-to-arc).

## B. Setting up a Github repository
To clone a GitHub repository to ARC, follow these steps:

1. **Ensure SSH Key Setup:** Make sure you’ve set up SSH key authentication on ARC, as described in the previous section.
2. **Copy Your Public Key to GitHub:** Add your public SSH key (from `~/.ssh/id_ed25519.pub`) to your GitHub account by going to Settings > SSH and GPG keys and pasting the key there.
3. **Clone the Repository:** Once your SSH key is linked to GitHub, you can clone the repository using the SSH URL. Run the following command on ARC:
```bash
git clone git@github.com:username/repository.git
```
The SSH address can be found on your repository's GitHub page under the 'Code' button. This downloads the repository to your ARC workspace. You can then navigate into the repository using `cd repository`.

Get back to [Section 3.1](#31-using-github).

## C. Setting Up a Python Virtual Environment

Setting up a Python Virtual Environment on ARC is a bit trickier, everything is explained in detail in the guide [Using Python on ARC](https://arc-software-guide.readthedocs.io/en/latest/python/anaconda.html). Here is a summary of the important steps.

### C.1 Interactive Session
You will first need an interactive session. To request an interactive session, when logging into ARC, run:

```bash
srun -p interactive --pty /bin/bash
```

Now we can start the set up of our virtual environment

### C.2 Virtual Environment

We will use Anaconda, the available Anaconda version can be found by typing 
```bash
module spider anaconda
```
To load the version of Anaconda you want, in this example we are using the latest version, use one of the following commands:

```bash
module load Anaconda3
```
or one of the specific Anaconda versions shown by module spider.

Once the module is loaded you can use the conda commands to create a virtual environment in your $DATA area. For example to create an environment named `myenv` in `$DATA` we can use the following commands:

```bash
export CONPREFIX=$DATA/myenv
conda create --prefix $CONPREFIX
```

ou can now use (activate) the environment by running one of the following commands:
```bash
source activate $CONPREFIX
```

You can then install package as usual with `pip` by typing 

```bash
pip install numpy
```

to install several package at the same time you can use a requirement file : 

```bash
pip install requirement.txt
```

That could have been created by running `pip freeze` in your local environment on your personal computer.

### C.3 Remove Conda cache

By default Anaconda will cache all packages installed using `pip install` into a directory in your `$HOME` area named `~/.conda/pkgs` before installing them into your virtual environment. Over time this has the potential to put you over quota in `$HOME`. If you find yourself over quota in `$HOME` check how much space is being used in `~/.conda/pkgs`

```bash
cd ~/.conda
du -sh pkgs
```

If the cache is indeed what puts you over quota, you can clean it by using 

```bash
module load Anaconda3
conda clean --packages --tarballs
```

Get back to [Section 4.4](#44-breakdown-of-the-submission-script--other-shell-commands).
