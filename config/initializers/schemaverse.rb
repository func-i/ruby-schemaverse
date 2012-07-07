require 'rubygems'
require 'active_record'
require 'yaml'

dbconfig = YAML::load(File.open('config/database.yml'))

USERNAME, PASSWORD = ENV['SCHEMAVERSE_USERNAME'], ENV['SCHEMAVERSE_PASSWORD']
ActiveRecord::Base.establish_connection(dbconfig.merge(:username => USERNAME, :password => PASSWORD))

load('config/initializers/db.rb')
load('lib/functions.rb')
