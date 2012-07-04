require 'rubygems'
require 'active_record'
require 'yaml'

dbconfig = YAML::load(File.open('config/database.yml'))

USERNAME, PASSWORD = ARGV[0], ARGV[1]
ActiveRecord::Base.establish_connection(dbconfig.merge(:username => USERNAME, :password => PASSWORD))

load('config/initializers/db.rb')
load('lib/functions.rb')
