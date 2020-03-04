# odin-facebook

This is the [final project](https://www.theodinproject.com/lessons/final-project) of the Odin Project Ruby on Rails course.

## Requirements

To run the application locally, you need:
 * [Ruby](https://www.ruby-lang.org/en/downloads/)
 * [Rails](https://guides.rubyonrails.org/getting_started.html)
 * [PostgreSQL](https://www.postgresql.org/download/)

### Set up PostgreSQL
The application by default Unix sockets to connect to a local Postgres database, using the default role name - same as the operating system user. So, you should either [create a database user](https://www.postgresql.org/docs/12/database-roles.html) with the same username, or tell the application your database access info in the _config/database.yml_ configuration file.

## Download and run

Download, or clone with git: `git clone git@github.com:themetar/odin-facebook.git`<br>
Then,
```
# Install gems
bundle install

# Initialize database
rails db:schema:load

# Optionally, seed the database
rails db:seed

# And run local web server
rails server
```