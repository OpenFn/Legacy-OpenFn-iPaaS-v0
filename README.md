OpenFN Bridge
=============

Master status: [![Build Status](https://travis-ci.org/OpenFn/OpenFn-Site.svg?branch=master)](https://travis-ci.org/OpenFn/OpenFn-Site)
Develop status: [![Build Status](https://travis-ci.org/OpenFn/OpenFn-Site.svg?branch=develop)](https://travis-ci.org/OpenFn/OpenFn-Site)

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


Ubuntu 14.10 Clean Slate Setup
---------------------------------

sudo apt-get rbenv

//Install postgres

sudo apt-get update
sudo apt-get -y install python-software-properties

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

lsb_release -c //note down the codename, and use it below:

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ codename-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'

sudo apt-get update
sudo apt-get install postgresql-9.3

sudo su postgres
creatuser -d -s -r taylor

cd into the /etc/postgresql/9.3/main/pg_hba.conf directory and edit pg_hba.conf

Setting up trust authentication for postgres

Ensure you have the following line somewhere at you pg_hba.conf file.

# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     trust

psql -l //to test

//Install Redis

sudo apt-get update
sudo apt-get install build-essential
sudo apt-get install tcl8.5

wget http://download.redis.io/releases/redis-2.8.9.tar.gz
tar xzf redis-2.8.9.tar.gz
cd redis-2.8.9

make

Run the recommended make test:

make test

Finish up by running make install, which installs the program system-wide.

sudo make install

Once the program has been installed, Redis comes with a built in script that sets up Redis to run as a background daemon.

To access the script move into the utils directory:

cd utils

From there, run the Ubuntu/Debian install script:

sudo ./install_server.sh

As the script runs, you can choose the default options by pressing enter. Once the script completes, the redis-server will be running in the background.

You can start and stop redis with these commands (the number depends on the port you set during the installation. 6379 is the default port setting):

sudo service redis_6379 start
sudo service redis_6379 stop

You can then access the redis database by typing the following command:

redis-cli

You now have Redis installed and running. The prompt will look like this:

redis 127.0.0.1:6379> 

To set Redis to automatically start at boot, run:

sudo update-rc.d redis_6379 defaults

//https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis


//configure GIT

sudo apt-get install git
git config --global color.ui true
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR@EMAIL.com"
ssh-keygen -t rsa -C "YOUR@EMAIL.com"

The next step is to take the newly generated SSH key and add it to your Github account. You want to copy and paste the output of the following command and paste it here.

cat ~/.ssh/id_rsa.pub

Once you've done this, you can check and see if it worked:

ssh -T git@github.com

You should get a message like this:

Hi excid3! You've successfully authenticated, but GitHub does not provide shel

//Set up GIT credentials

cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.1.5
rbenv global 2.1.5
gem install bundler
rbenv rehash

sudo apt-get install libpq-dev
gem install pg

bundle install
rbenv rehash 

//Install Heroku Toolbelt

wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

Clone the staging database over
heroku pg:pull HEROKU_POSTGRESQL_PURPLE_URL thebridge_development --app the-staging-bridge

//try to stop this continual fail with rails server

I’d try do this:

sudo apt-get install libreadline-dev


then uninstall your copy of ruby, and reinstall it, so something like:

rbenv uninstall 2.1.5
rbenv install 2.1.5
rbenv local 2.1.5
gem install bundler
rbenv rehash
bundle install