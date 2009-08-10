Streetprint 5.0
===============

Visit the Streetprint [website][website] at http://www.streetprint.org to find out more about the Streetprint Engine.

A Project of the [CRCStudio][studio]

Setup
-----

First clone the project.

    git clone git://github.com/crcstudio/streetprint.git

Now install all the required gems:

    sudo rake gems:install

Customize config/database.yml to your liking and then run these two tasks to setup the database:

    rake db:create
    rake db:schema:load

Mail server settings will need to be set in config/email.yml.

Make sure you have [Sphinx][sphinx] installed and then set the appropriate path to searchd in config/sphinx.yml (`rake ts:config` should do this for you).  You can now start sphinx.

    rake ts:index
    rake ts:start

You will also need to have [ImageMagick][imagemagick] and [rmagick][rmagick] installed. For anyone on OS X there is a ruby script that removes the pain of the [rmagick installation][rmagick-osx].  

You can run the tests to make sure that everything is working however this will require installing all the testing dependencies including [Selenium][selenium]. Note that Selenium currently requires the installation of *[Firefox 3.0.11][ff3011]* and that __newer versions of Firefox will not work__.

    sudo gem install Selenium

    sudo rake gems:install RAILS_ENV=test
    rake test:all

You will probably want to customize the info on the main visitor page, etc. We will be putting together tools to do this but priority one is getting the site up for researchers so this might take a while.


[sphinx]:http://sphinxsearch.com
[website]:http://www.streetprint.org
[studio]:http://www.crcstudio.org
[imagemagick]:http://www.imagemagick.org/script/index.php
[selenium]:http://seleniumhq.org
[ff3011]:http://www.mozilla.com/en-US/firefox/all-older.html
[rmagick]:http://rmagick.rubyforge.org/
[rmagick-osx]:http://rubyforge.org/frs/download.php/53894/rm_install-1.2.2.zip