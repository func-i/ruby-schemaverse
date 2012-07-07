require 'rubygems'
require 'active_record'
require 'yaml'

USERNAME = ENV['SCHEMAVERSE_USERNAME']

ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])

load('config/initializers/db.rb')
load('lib/functions.rb')
