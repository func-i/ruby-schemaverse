require 'rubygems'
require 'active_record'
require 'yaml'


if ENV['DATABASE_URL'].nil?
	dbconfig = YAML::load(File.open('config/database.yml'))

	USERNAME, PASSWORD = ARGV[0], ARGV[1]
	ActiveRecord::Base.establish_connection(dbconfig.merge(:username => USERNAME, :password => PASSWORD))
else
	USERNAME = ENV['SCHEMAVERSE_USERNAME']
	ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])
end

load('config/initializers/db.rb')
load('lib/functions.rb')
