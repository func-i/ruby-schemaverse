raise "Username and Password Required" unless ARGV[0] && ARGV[1]
load('config/initializers/schemaverse.rb')

new_ship = MyShip.create!(
  :name => "A New Ship",
  :attack => 5,
  :defense => 5,
  :engineering => 5,
  :prospecting => 5
)

#new_ship.upgrade('MAX_HEALTH', 5)

MyShip.mine_all_planets

raise Planet.my_planets.inspect