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
  ((my_player.balance + my_player.fuel_reserve) / 100000).times do
    my_player.convert_fuel_to_money(100000) if my_player.balance < 10000

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
      skill_remaining = max_ship_skill - (ship.prospecting + ship.engineering + ship.defense + ship.attack)
      ship.upgrade('PROSPECTING', skill_remaining < 140 ? skill_remaining.to_i : 140)
    end
  end
end

home.ships.where("action IS NULL OR action = ''").each do |ship|
  # These ships aren't mining our home and are extra, lets get them to explore
  # Set them to explore
  ship.update_attributes(:name => "#{USERNAME}-armada".capitalize, :action => 'ATTACK')
  skill_remaining = max_ship_skill - (ship.prospecting + ship.engineering + ship.defense + ship.attack)
  ship.upgrade('ATTACK', skill_remaining < 140 ? skill_remaining.to_i : 140)
  ship.course_control(ship.max_speed, rand(360))
end

MyShip.where("name LIKE ?", "%armada").each do |ship|
  skill_remaining = max_ship_skill - (ship.prospecting + ship.engineering + ship.defense + ship.attack)
  ship.upgrade('ATTACK', skill_remaining < 140 ? skill_remaining.to_i : 140)
  if ship.planets_in_range.first && !Planet.my_planets.collect(&:id).include?(ship.planets_in_range.first.planet.id)
    planet_in_range = ship.planets_in_range.first

    unless planet_in_range.ship_location == planet_in_range.planet_location
      # This isn't a planet that I have conquered yet, lets move to it'
      ship.course_control(ship.max_speed, nil, "#{planet_in_range.planet_location[1..-1].chop}")
    else
      # The ship has arrived at the planet
      ship.update_attributes(:action => "MINE", :action_target_id => planet_in_range.planet)
      Planet.find(planet_in_range.planet).update_attribute("name", Planet.get_new_planet_name)
    end
  end
end

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

# Build tons of ships and send them in all directions for now

((my_player.balance + my_player.fuel_reserve) / 105000).times do
  begin
    my_player.convert_fuel_to_money(105000) if my_player.balance < 105000
    # If you can build another miner at home, do so
    ship = MyShip.create(:name => "#{USERNAME}-armada")
    ship = ship.reload
    ship.update_attribute("action", "ATTACK")
    ship.upgrade("ATTACK", 100)
    sleep(1)
    ship.upgrade("DEFENSE", 100)
    ship.course_control(ship.max_speed, rand(360))
  rescue
  end
end

puts "Round: #{TicSeq.first.last_value}"
puts "#{USERNAME}: $#{my_player.balance}, #{my_player.fuel_reserve} fuel"
roaming_ships = [MyShip.all]
Planet.my_planets.each do |planet|
  puts planet.name
  puts "Ships: #{planet.ships.size}"
  planet.ships.each do |ship|
    puts "     #{ship.name}: A: #{ship.attack}, D: #{ship.defense}, P: #{ship.prospecting}, E: #{ship.engineering}, ACTION: #{ship.action}"
    roaming_ships = roaming_ships - ship
  end
end

puts "Rogue Ships: #{roaming_ships.size}"
roaming_ships.each do |ship|
  puts "     #{ship.name}: A: #{ship.attack}, D: #{ship.defense}, P: #{ship.prospecting}, E: #{ship.engineering}, ACTION: #{ship.action}"
end

