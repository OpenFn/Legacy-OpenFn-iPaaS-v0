OpenFN Bridge
=============

Getting Started
---------------

`rbenv install 2.1.5`  
`rbenv local 2.1.5`  
`gem install bundler`  
`rbenv rehash`  
`bundle install`  
`rbenv rehash`  

**Copy the configuration defaults**  
`cp config/database.yml.example config/database.yml`  
`cp config/application.yml.template config/application.yml`  

**Setting up trust authentication for postgres**  

Ensure you have the following line somewhere at you `pg_hba.conf` file.  
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     trust
```
  
*The `pg_hba.conf` file is located in `/etc/postgresql/9.3/main/pg_hba.conf` on Ubuntu*

**Clone the staging database over**  
`heroku pg:pull HEROKU_POSTGRESQL_PURPLE_URL thebridge_development --app the-staging-bridge`  

Configuration
-------------

The application uses [figaro](https://github.com/laserlemon/figaro) to manage
configuration.

Using the 12-factor application pattern, anything in the `config/application.yml`
will be seeded to the environment as Rails initializes.

There is a template located in `config/application.yml.template`

To get started, copy it:

    $ cp config/application.yml.template config/application.yml

Features
--------

Using ENV variables certain aspects of the application can be configured or
disabled.

- `GA_TRACKING_CODE`  
  Enabled Google Analytics by setting this to your GA tracking code.
- `SYNC_WITH_SALESFORCE`  
  When a user record is changed, set this to "true" to update the Salesforce
  backend.

Workers
-------

The application uses [sidekiq](https://github.com/mperham/sidekiq) to perform
background tasks.

The environment variable `REDIS_URL` is required to be set for any environment
where redis is not available on `localhost`.

Sidekiq includes a UI for managing the queues, this is available at the 
`/sidekiq` URL on the given server.

The management UI requires you to be logged in as admin user.

Running Tests
-------------

This appication has spring and guard installed. So running tests should be
super easy and fast.

    # Running via rspec
    $ spring rspec

    # Running guard
    $ guard

Building Mapping Fixtures
-------------------------

There is a rake task provided for this purpose:

    $ rake db:fixtures:dump[x]
    # Where x is the ID of the mapping.

In order to load the fixtures, you will need to use namespacing.
The files are stored in `spec/fixtures/[mapping name]/[table name].yml`.
So the following method is used to load namespaced fixtures:  

```ruby
  fixtures "[mapping name]/mappings"
  set_fixture_class "[mapping name]/mappings" => Mapping
```

Contribution Guide
------------------

We use Github to track our features and bugs, so head over to 
the [issues](https://github.com/OpenFn/OpenFn-Site/issues) page.

Being a remote team, we encourage everyone to work out in the open.
Part of that is being vocal, asking questions, giving feedback and generally
being a good *person*.

When doing pull requests, there are a few critera that need to be met:

- Up to date with develop  
    On the theme of being nice, make sure your branch can be cleanly merged
    with develop.

    We don't have super strong oppinions (yet) on rebasing vs. merging, but
    the least you can do is resolve your merge conflicts before we get your
    changes upstream.
    
    **#protip** keep your branches lean, if you feel stuff getting crazy theres a
    good chance we underestimated the issue.  
    Maybe it's 2 issues?

- Tag your commits  
    Since we work using Github Issues, it's super cool to be able to track  
    a feature/bug in one place. So please use the #[issue number] convention
    on your commits.

    This way everyone knows whats going on, and it helps keep you focussed on
    a single issue.

- No mixed pull requests  
    Seriously, shouldn't need to tell you this. Keep your branches on point  
    and focussed on what the issue describes.

    No one likes cherry picking. We will totally ask you to split your commits
    out if you mix code from other issues.

- Clean commits  
    Squashing commits is a great way to compact and condense your work, and  
    allows a scattered commit trail to end up being clear and concise.

    We all have to live with the code history, so try avoid 
    'oops, I forgot one thing' commits.

Any questions or feedback, pleasure raise an issue. We're all about improving
things.

[Don't be a dickm with Git](http://www.alexefish.com/post/52e5652520a0460016000002)  
[A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)

