require 'rubygems'
require 'active_record'
require 'yaml'


ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])

load('config/initializers/db.rb')
load('lib/functions.rb')
