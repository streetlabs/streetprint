Streetprint 5.0
===============

Visit the Streetprint [website][website] at http://www.streetprint.org to find out more about the Streetprint Engine.

A Project of the [CRCStudio][studio]

Setup
-----

First clone the project.

    git clone git://github.com/crcstudio/streetprint.git

Now install all the required gems:

    rake gems:install

Customize config/database.yml to your liking and then run these two tasks to setup the database:

    rake db:create
    rake db:schema:load
    rake db:seed

Mail server settings will need to be set in config/email.yml.

Make sure you have [Sphinx][sphinx] installed and then set the appropriate path to searchd in config/sphinx.yml (rake ts:config should do this for you).  You can now start sphinx.

    rake ts:index
    rake ts:start

You will also need to have [ImageMagick][imagemagick] installed.

You can run the tests to make sure that everything is working however this will require installing all the testing dependencies including [Selenium][selenium].

    rake gems:install RAILS_ENV=test
    rake test:all

[sphinx]:http://sphinxsearch.com
[website]:http://www.streetprint.org
[studio]:http://www.crcstudio.org
[imagemagick]:http://www.imagemagick.org/script/index.php
[selenium]:http://seleniumhq.org
