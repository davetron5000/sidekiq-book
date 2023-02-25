# Dev Environment for Sidekiq Book

This is the dev environment used for my Sidekiq book.  It includes everything you need to get up and running as
well as the initial state of the Rails app used in the book.

## Setup

1. Ensure you have Docker installed
2. Edit `bin/vars` and change `ACCOUNT` to something else. It doesn't have to be a real Dockerhub account. Just make sure it's not `davetron5000`.
3. `bin/build`
4. `bin/start`
5. In another terminal, come back here and do `bin/exec bash`.
6. You are now "logged in" to the Docker container.
