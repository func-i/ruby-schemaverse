raise "Username and Password Required" unless ARGV[0] && ARGV[1]
load('config/initializers/schemaverse.rb')

Planet.with_my_ships.each do |planet|
  puts planet.name
end