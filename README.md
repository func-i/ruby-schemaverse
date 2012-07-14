Heroku ruby-schemaverse
================

A ruby wrapper for the game Schemaverse created by Abstrct, written by Sailias.

The Schemaverse is a space-based strategy game implemented entirely within a PostgreSQL database. Compete against other players using raw SQL commands to command your fleet. Or, if your PL/pgSQL-foo is strong, wield it to write AI and have your fleet command itself!
Come to #Schemaverse on irc.freenode.net if you are looking for some help or friendly banter.

To play you must be a registered user on the database you are connecting to.   
For the public database you can register at http://schemaverse.com.

This also assumes you have registered with Heroku (http://www.heroku.com) and you have downloaded their Heroku Toolbelt (https://toolbelt.herokuapp.com)

Documentation
--------------------------------

You can view the documentation [here](http://www.rubydoc.info/github/func-i/ruby-schemaverse/master/frames)


Usage (Deployed to Heroku):
-----------------------------

  git clone git://github.com/func-i/ruby-schemaverse.git ruby-schemaverse  
  cd ruby-schemaverse  
  heroku create  

  heroku config:add SCHEMAVERSE_USERNAME=&lt;username&gt;  
  heroku config:add DATABASE_URL=postgres://&lt;username&gt;:&lt;password&gt;@db.schemaverse.com/schemaverse  
  
  git push heroku master  

  heroku ps:scale worker=1  

Testing
-------------------------------

Uses RSpec to test the functions inside Schemaverse and their return functions.  Unfortunately the easiest way to test
this is by connecting as a user.  This will eventually be changed and the functionality will be stubbed out.

### Create a test.yml file

Copy and rename the test.yml.example file and populate it with your or a fake account's credentials.  This file is ignored in the .gitignore
so don't worry about committing it.

### Run a test

Like any other rspec test

> rspec spec/models/my_player_spec.rb

Feel free to enhance the tests and submit pull requests.