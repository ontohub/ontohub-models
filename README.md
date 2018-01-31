[![Build Status](https://travis-ci.org/ontohub/ontohub-models.svg?branch=master)](https://travis-ci.org/ontohub/ontohub-models)
[![codecov](https://codecov.io/gh/ontohub/ontohub-models/branch/master/graph/badge.svg)](https://codecov.io/gh/ontohub/ontohub-models)
[![Code Climate](https://codeclimate.com/github/ontohub/ontohub-models/badges/gpa.svg)](https://codeclimate.com/github/ontohub/ontohub-models)
[![GitHub issues](https://img.shields.io/github/issues/ontohub/ontohub-models.svg?maxAge=2592000)](https://waffle.io/ontohub/ontohub-backend?source=ontohub%2Fontohub-models)

# ontohub-models
Data model for Ontohub, to be used by [ontohub-backend](https://github.com/ontohub/ontohub-backend) and by [hets-ontohub-adapter](https://github.com/ontohub/hets-ontohub-adapter).
It is created as a Rails engine.

## Development Guide

In the following, the basic development workflow is described.

### Run Migrations
The database can be crated with `RAILS_ENV=test rails db:create`, which usually is only run once.
For migrations, run `rails db:migrate`.
If, for some reason, the database must be dropped and created anew, run `RAILS_ENV=test rails db:reset`.

The migrations are shared with the host application that requires this Rails engine.
Instead of copying them over to the host application, the migrations can reside only in this Rails engine.
When `rake db:migrate` is executed in the host, *only* the migrations of this Rails engine are executed using the host's `database.yml`.

### Create New Models
For future models, the generator can be invoked directly from the root of this repository, as in
```
rails g model Repository name:string slug:string description:text created_at:datetime updated_at:datetime
```
This creates the model file and the migration file
Note that Sequel does not generate timestamp columns on its own, hence, they have to be specified explicitly in the generate command.

### Run tests
To run tests on the models, simply run `rake`, `rake spec` or `rspec` from the root of this repository.

There is, however, no rails console or server that we can use.
We can only use breakpoints in the specs for trial and error development.
