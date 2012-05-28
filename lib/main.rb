raise "Username and Password Required" unless ARGV[0] && ARGV[1]

require 'rubygems'
require 'active_record'

require 'yaml'
dbconfig = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig.merge(:username => ARGV[0], :password => ARGV[1]))

require_relative 'planet'

p = Planet.first
p.attributes.each_pair do |key, value|
  puts "#{key} => #{value}"
end