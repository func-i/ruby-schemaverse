raise "Username and Password Required" unless (ARGV[0] && ARGV[1]) || (ENV['DATABASE_URL'] && ENV['SCHEMAVERSE_USERNAME'])
load('config/initializers/environment.rb')

Schemaverse.new.play




