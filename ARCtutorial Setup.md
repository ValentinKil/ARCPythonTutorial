# ARC Cluster Tutorial for Python Users : Set up

## 1. Accessing the ARC Cluster

### 1.0 Getting an ARC account

To access and use ARC you need to be attached to a project, any Academic of the University of Oxford can create a project. Once project is created you can apply to get an ARC account [here](https://www.arc.ox.ac.uk/arc-user-registration-page). The project manager will have to validate your application, and once this is done you will receive an email with your username and a separated email with a temporary password. 

### 1.1 Logging in to ARC
To access the ARC cluster from a Mac we will use ssh. This will only works works if you are on the University of Oxford network. If you are not on the University network, you should use the [University VPN](https://help.it.ox.ac.uk/vpn#tab-4157281). 

To connect to the ARC cluster:
```bash
ssh abcd1234@arc-login.arc.ox.ac.uk
```
Where `coll1234` is your actual ARC username, which should be your Oxford SSO. When you log in you are on your `$HOME` directory, you're the only one to get access to this repository and you can store up to 20GB into it. The other important directory is the `$DATA` where 5TB are available to be share among all project members.

### 1.2 Changing your password

The first thing to do is to change your password, for that type 
```bash
passwd
```
You will be prompted to enter your current password, followed by the new password. After entering it twice, your password will be updated.

### 1.3 SSH Key Setup (Optional)
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

## 2. Setting up a Github repository
To clone a GitHub repository to ARC, follow these steps:

1. **Ensure SSH Key Setup:** Make sure you’ve set up SSH key authentication on ARC, as described in the previous section.
2. **Copy Your Public Key to GitHub:** Add your public SSH key (from `~/.ssh/id_ed25519.pub`) to your GitHub account by going to Settings > SSH and GPG keys and pasting the key there.
3. **Clone the Repository:** Once your SSH key is linked to GitHub, you can clone the repository using the SSH URL. Run the following command on ARC:
```bash
git clone git@github.com:username/repository.git
```
The SSH address can be found on your repository's GitHub page under the 'Code' button. This downloads the repository to your ARC workspace. You can then navigate into the repository using `cd repository`.

## 3. Setting Up a Python Virtual Environment

Setting up a Python Virtual Environment on ARC its a bit tricker, everything is explain in detail in the guide [Using Python on ARC](https://arc-software-guide.readthedocs.io/en/latest/python/anaconda.html). Here is the summary of the important step. 

### 3.1 Interactive Session
You will first need an interactive session. To request an interactive session, when log in ARC pormpt:

```bash
srun -p interactive --pty /bin/bash
```

Now we can start the set up of our virtual environment

### 3.2 Virtual Environment

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

### 3.3 Remove Conda cache

By default Anaconda will cache all packages installed using `pip install` into a directory in your `$HOME` area named `~/.conda/pkgs` before installing them into your virtual environment. Over time this has the potential to put you over quota in `$HOME`. If you find yourself over quota in `$HOME` check how much space is being used in `~/.conda/pkgs`

```bash
cd ~/.conda
du -sh pkgs
```

If the cache is indeed what put you out of quota you can clean it by using 

```bash
module load Anaconda3
conda clean --packages --tarballs
```
