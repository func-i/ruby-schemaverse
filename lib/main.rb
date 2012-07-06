raise "Username and Password Required" unless ARGV[0] && ARGV[1]
load('config/initializers/schemaverse.rb')

if Planet.where(:name => Planet.my_home_name).empty?
  Planet.my_planets.first.update_attribute('name', Planet.my_home_name)
end

my_player = MyPlayer.first
home = Planet.home
max_ship_skill = Functions.get_numeric_variable('MAX_SHIP_SKILL')

# Adding cool names to my planets
Planet.my_planets.not_home.each do |planet|
  planet.update_attribute('name', Planet.get_new_planet_name)
end

if home.ships.size < home.mine_limit
  ((my_player.balance + my_player.fuel_reserve) / 1000).times do
    my_player.convert_fuel_to_money(1000) if my_player.balance < 1000

    # If you can build another miner at home, do so
    miner = home.ships.create(:name => "#{home.name}-miner", :action => "MINE", :action_target_id => home.id)

    # Then upgrade it's prospecting
    miner.upgrade('PROSPECTING', 100)
    break if home.ships.size >= 30
  end
else
  # If I have the same amount of miners on my home planet as the limit allows for, it makes more sense to upgrade the ships instead
  unless home.ships.average("prospecting+engineering+defense+attack") == max_ship_skill
    home.ships.where("(prospecting+engineering+defense+attack) < ?", max_ship_skill).each do |ship|
      my_player.convert_fuel_to_money(5000) if my_player.balance < 5000
      skill_remaining = max_ship_skill - (ship.prospecting + ship.engineering + ship.defense + ship.attack)
      ship.upgrade('PROSPECTING', skill_remaining < 140 ? skill_remaining.to_i : 140)
    end
  end
end

# Build defenders for our home
if home.ships.where("name LIKE ?", '%defender').size < 50
  ((my_player.balance + my_player.fuel_reserve) / 1000).times do
    my_player.convert_fuel_to_money(1000) if my_player.balance < 1000

    # If you can build another miner at home, do so
    miner = home.ships.create(:name => "#{home.name}-defender", :action => "ATTACK")

    # Then upgrade it's prospecting
    miner.upgrade('ATTACK', 240)
    miner.upgrade('DEFENSE', 240)
    break if home.ships.where("name LIKE ?", '%defender').count >= 50
  end
end


# Start to build and mass armada ships at home
#((my_player.balance + my_player.fuel_reserve) / 25000).times do
#  my_player.convert_fuel_to_money(25000) if my_player.balance < 25000
#  # If you can build another miner at home, do so
#  ship = home.ships.create(:name => "#{USERNAME}-armada", :action => "ATTACK")
#  ship.upgrade("ATTACK", 100)
#  ship.upgrade("DEFENSE", 100)
#end

home.ships.where("name LIKE ?", "%armada").all.each_slice(80).to_a.each do |rogue_group|
  if rogue_group.size == 80
    direction = rand(360)
    rogue_group.each do |rogue_ship|
      rogue_ship.course_control(rogue_ship.max_speed / 2, direction)
      new_name = MyShip.get_new_ship_name
      rogue_ship.update_attribute("name", "#{new_name}")
    end
  end
end


#MyShip.where("name LIKE ?", "%armada").each do |ship|
#  skill_remaining = max_ship_skill - (ship.prospecting + ship.engineering + ship.defense + ship.attack)
#  ship.upgrade('ATTACK', skill_remaining < 140 ? skill_remaining.to_i : 140)
#  if ship.planets_in_range.first && !Planet.my_planets.collect(&:id).include?(ship.planets_in_range.first.planet.id)
#    planet_in_range = ship.planets_in_range.first
#
#    unless planet_in_range.ship_location == planet_in_range.planet_location
#      # This isn't a planet that I have conquered yet, lets move to it'
#      ship.course_control(ship.max_speed, nil, "#{planet_in_range.planet_location[1..-1].chop}")
#    else
#      # The ship has arrived at the planet
#      ship.update_attributes(:action => "MINE", :action_target_id => planet_in_range.planet)
#      Planet.find(planet_in_range.planet).update_attribute("name", Planet.get_new_planet_name)
#    end
#  end
#end

# Repair the ships
MyShip.where("current_health = 0").each do |ship|
  ship.repair(ship.id)
end

Planet.my_planets.not_home.each do |planet|
  ((my_player.balance + my_player.fuel_reserve) / 3500).times do
    my_player.convert_fuel_to_money(3500) if my_player.balance < 3500
    raise planet.ships.inspect

    # If you can build another miner at home, do so
    miner = planet.ships.create(:name => "#{planet.name}-miner", :action => "MINE", :action_target_id => planet.id)

    # Then upgrade it's prospecting
    miner.upgrade('PROSPECTING', 100)
    break if planet.ships.size >= 30
  end
end

puts "Round: #{TicSeq.first.last_value}"
puts "#{USERNAME}: $#{my_player.balance}, #{my_player.fuel_reserve} fuel"
roaming_ships = MyShip.all
Planet.my_planets.each do |planet|
  puts planet.name
  puts "Ships: #{planet.ships.size}"
  planet.ships.each do |ship|
    puts "     #{ship.name}: A: #{ship.attack}, D: #{ship.defense}, P: #{ship.prospecting}, E: #{ship.engineering}, ACTION: #{ship.action}"
    roaming_ships = roaming_ships - [ship]
  end
end

puts "Rogue Ships: #{roaming_ships.size}"
roaming_ships.each do |ship|
  puts "     #{ship.name}: A: #{ship.attack}, D: #{ship.defense}, P: #{ship.prospecting}, E: #{ship.engineering}, ACTION: #{ship.action}"
end

