# Docker Automation Scripts

Each script responds to `-h` which will explain its purpose and usage.

The other files:

* `docker-compose.base.env` - This is the basis for environment variables passed to the Docker commands.  It is a per-project
configuration file that is checked in.
* `docker-compose.env` - This is the fully-derived file used to pass environment variables to the Docker commands. It is based on
`docker-compose.base.env` and `docker-compose.local.env` and should not be checked into version control.  `bin/setup` can create this
file if you delete it.
* `docker-compose.local.env` - This is a per-developer configuration file used to create `docker-compose.env`.  This should not be
checked into version control.  `bin/setup` can walk you through re-creating it if it is deleted.
* `dx.sh.lib` - Common bash functions needed by the various scripts
* `setupkit.sh.lib` - Common bash functions needed by the various scripts
