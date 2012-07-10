require 'rubygems'
require 'active_record'
require 'yaml'


if ENV['DATABASE_URL'].nil?
	dbconfig = YAML::load(File.open('config/database.yml'))

	USERNAME, PASSWORD = ARGV[0], ARGV[1]
  unless ENV['ENV'] == 'test'
    connection_information = dbconfig['production'].merge(:username => USERNAME, :password => PASSWORD)
  else
    connection_information = dbconfig['test']
  end

	ActiveRecord::Base.establish_connection(connection_information)
else
	USERNAME = ENV['SCHEMAVERSE_USERNAME']
	ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])
end

load('config/initializers/db.rb')
load('lib/functions.rb')
