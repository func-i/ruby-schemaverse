require 'rubygems'
require 'active_record'
require 'yaml'

dbconfig = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig.merge(:username => ARGV[0], :password => ARGV[1]))

load('config/initializers/db.rb')
load('lib/functions.rb')
