# Phacepook

Phacepook is a social network (Facebook clone) website built with Ruby on Rails.

## Requirements

To run the application locally, you need:
 * [Ruby](https://www.ruby-lang.org/en/downloads/)
 * [Rails](https://guides.rubyonrails.org/getting_started.html)
 * [PostgreSQL](https://www.postgresql.org/download/)
 * [Yarn](https://yarnpkg.com/getting-started/install) for Tailwind CSS and Webpacker

### Setting up PostgreSQL

The application, by default, uses Unix sockets to connect to a local Postgres database, using the default role name - same as the operating system user. So, you should either [create a database user](https://www.postgresql.org/docs/12/database-roles.html) with the same username, or tell the application to use your custom database access info via the _config/database.yml_ configuration file.

## Running the app

Download, or clone with git: `git clone git@github.com:themetar/odin-facebook.git`<br>
Then,
```
# Install gems
bundle install

# Create the database
rails db:create

# Initialize the database
rails db:schema:load

# Optionally, seed the database
rails db:seed

# And start the local web server
rails server
```
## Features

* User authentication and OAuth with [Devise](https://github.com/heartcombo/devise/)
* Database ORM with Active Record
* ERB component partials

## Origin

This is the [final project](https://www.theodinproject.com/lessons/final-project) assignment of the Odin Project Ruby on Rails course.
