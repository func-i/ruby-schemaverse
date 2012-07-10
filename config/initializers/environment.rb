require 'rubygems'
require 'active_record'
require 'yaml'


if ENV['DATABASE_URL'].nil?
	db_config = YAML::load(File.open('config/database.yml'))

  unless ENV['ENV'] == 'test'
    USERNAME, PASSWORD = ARGV[0], ARGV[1]
  else
    test_config = YAML::load(File.open('config/test.yml'))
    USERNAME = test_config['username']
    PASSWORD = test_config['password']
  end

  db_config.merge!(:username => USERNAME, :password => PASSWORD)

	ActiveRecord::Base.establish_connection(db_config)
else
	USERNAME = ENV['SCHEMAVERSE_USERNAME']
	ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])
end

load('config/initializers/db.rb')
load('lib/functions.rb')
