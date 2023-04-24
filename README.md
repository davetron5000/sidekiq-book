# Dev Environment for Sidekiq Book

This is the dev environment used for my Sidekiq book.  It includes everything you need to get up and running as
well as the initial state of the Rails app used in the book.

## How this Works at a High Level

This will use Docker Compose to run a few services the app will need. It will also run a container in which you can run all the various
commands needed to work on a Rails app.  This devcontainer will map your computer's files to it, so you can edit the files on your
computer using the editor of your choice, but run all the Rails and Ruby commands in the container. This means you do not have to
manage any Ruby installation or install any Ruby Gem on your computer.

## Setup

1. [Ensure you have Docker installed](https://docs.docker.com/get-docker/)
1. `dx/setup`
1. `dx/build`
1. `dx/start`
1. `dx/exec bash`
1. You are now "logged in" to the Docker container.

## What each file here is

Each directory that requires explanation has a README, so look for those.

In this directory:

* `dx/` - Directory for all the shell scripts and files needed to run the dev environment.
* `sidekiq-book/` - The Rails app used for the basis of the book.  All code changes made in the book are made relative to this app.
* `.gitignore` - File of files to ignore in Git
* `Dockerfile.dx` - The `Dockerfile` used to build an image you can use to run a container to do the development for the app. It is
liberally commented to explain what's going on in there.
* `README.md` - This file
* `authorized_keys` - Used by the book's build system on my computer. You don't need to worry about this or use it. See `Dockerfile.dx`
* `docker-compose.dx.yml` - A Docker Compose file that runs all the servers.  This file is liberally commented.
