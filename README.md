Heroku ruby-schemaverse
================

To play you must be a registered user on the database you are connecting to. For the public database you can register at http://schemaverse.com.

This also assumes you have registered with Heroku (http://www.heroku.com) and you have downloaded their Heroku Toolbelt (https://toolbelt.herokuapp.com)

Usage (Deployed to Heroku):

  git clone git://github.com/func-i/ruby-schemaverse.git ruby-schemaverse  
  cd ruby-schemaverse  
  heroku create  

  heroku config:add SCHEMAVERSE_USERNAME=<username>  
  heroku config:add DATABASE_URL=postgres://<username>:<password>@db.schemaverse.com/schemaverse  
  
  git push heroku master  

  heroku ps:scale worker=1  
