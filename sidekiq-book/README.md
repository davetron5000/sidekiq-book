# sidekiq-book example app

This is an example app used in my Sidekiq book.  This is the base app upon which all changes in the book are made.  It is generally a
vanilla Rails app that does a few things:

* Allows the creation of an order, which involves communicating with external services
* Shows the status of the external services
* Allows configuration of the behavior of the external services

## Setup

1. Ensure you have set up your dev environment as described in the README in the parent directory.
1. `dx/exec bash` to "log in" to the Docker container
1. `cd sidekiq-book`
1. `bin/setup`
1. `bin/ci`
1. `bin/dev`

Assuming setup worked and the tests pass, the app should be running, and you can access it on your computer at `http://localhost:3000`

## Doing Development

In general, any Rails command can be run inside the Docker container. I like to have a terminal open to `bin/exec bash`.

Other handy things to know:

* `bin/rails dev:reset` will reset a lot of state: Redis, the fake APIs, etc.  Do this if the app seems like it's not doing what you
want
* `bin/setup` is idempotent and safe to run, however it will blow away your dev database.  Embrace this as a feature
* `bin/psql` will establish a SQL connection to the database
* `bin/db-migrate` and `bin/db-rollback` are more reliable means for managing migrations.
* `bin/run` starts the app but without the front-end bundlers.  You don't need this. The book's build system use it to prevent esbuild
or tailwind from running while taking screenshots.

## Rails Things You May Need to Know About

* This uses dotenv to manage configuration.  You can examine `.env.development` and `.env.test`.  In general, this app uses the
environment to get configuration, such as the database connection string.  `config/database.yml` is not used.
* `config/initializers/postgres.rb` sets the default timestamp data type to `timestamp with time zone` which is what Rails should be
doing but doesn't for whatever reason.
* `config/initializers/error_catcher.rb` is to set up the fake error catcher, though be aware it doesn't actually catch unhandled
exceptions from the app. It's just there so that in the book, the reader can set up Sidekiq to use it.
* This is using the default Rails testing framework and not RSpec just to simplify things, but it's using Factory Bot instead of fixtures because fixutres does not seem to work when you use foreign key constraints.
* `Gemfile` has documentation for each non-standard gem

## Non-Rails Things To Know About

* This app uses Tailwind CSS.  There aren't many customizations, but you can examine `app/assets/stylesheets/application.tailwind.css`
for more info. There are comments in there to explain what's going on
* There is some limited vanilla JavaScript in app/javascript/application.js
* `app/services` contains general code and business logic.
