# lunaci-install
LunaCI install is a helper script used to prepare the LunaCI Docker image.

## Purpose

LunaCI is a bot used to generate the [LuaDist2 package repositories](https://github.com/LuaDist2).
It does so by using 3 cooperating modules - [Rocks2Git](https://github.com/LuaDist-core/rocks2git),
[Github-Pusher](https://github.com/LuaDist-core/github-pusher) and
[Git2Travis](https://github.com/LuaDist-core/git2travis).

This repository contains an installation script to glue all of these together and create a single
executable Docker container.

## Prerequisites

Before installing, make sure you have the following:

- a Linux-based operating system
- a Github organisation which will contain the generated repositories
   - this organisation needs to contain a repository called `manifest` (this is where the LuaDist manifest will go)
- a Travis CI account with access to this organisation
- access tokens to both of these (the Github organisation and Travis)
- any new Git version
- any new Docker version

## Installation

The installation process is as follows:

````
# Clone the repository wherever you like.
git clone https://github.com/LuaDist-core/lunaci-install lunaci
cd lunaci

# Run the install script.
# If successful, there should be a new '_install' subfolder.
./install.sh

cd _install

# You need to edit the env.list file and fill in at least:
#  - GITHUB_ORG_NAME
#  - GITHUB_TOKEN
#  - TRAVIS_TOKEN
#
# The env.list file contains a brief description of what these variables do.
#
# To edit env.list, you can, of course, use any editor you like, nvim
# is used simply as an example here.
nvim env.list

# You can now build a Docker image from the current directory.
docker build -t lunaci .
````

## Usage

When you're ready, you can run the Docker image you've created in the installation step.
There are a few helper scripts to assist you with that (the `docker_run*.sh` files).
Feel free to take a look inside.

Each of them runs Docker with a few essential flags, like setting the `--env-file` to
`env.list` and mounting the `data` and `logs` subfolders - this ensures the container
is configured correctly and you have access to the data and logs it produces.

These examples assume you've tagged the image `lunaci` and you're inside the `_install`
folder created earlier. You could have moved it anywhere else and named it whatever
you like, the important thing is that the structure of this directory remains intact.

````
# Run Docker as a daemon - a process in the background - this is probably the option you want.
# After you run this command, you can use your standard Docker commands to interact
# with the container (docker container ls, docker logs <container>, etc.).
./docker_run_daemon.sh lunaci

# Run Docker in the foreground.
./docker_run.sh lunaci

# Run Docker interactively - you can 'cd' around and explore the files.
./docker_run_interactive.sh lunaci
````

## Ownership issues

If you can't manipulate the `data` and `logs` folders, there may be some ownership issues.
You can resolve this by simply running chown:

````
sudo chown -R <your_username> data
sudo chown -R <your_username> logs
````
