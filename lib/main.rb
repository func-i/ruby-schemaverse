class Schemaverse
  def initialize
    if Planet.where(:name => Planet.my_home_name).empty?
      Planet.my_planets.first.update_attribute('name', Planet.my_home_name)
    end

    @my_player = MyPlayer.first
    @home = Planet.home
    @max_ship_skill = Functions.get_numeric_variable('MAX_SHIP_SKILL')
    @max_ship_fuel = Functions.get_numeric_variable('MAX_SHIP_FUEL')
  end

  def play
    last_tic = 0

    while true
      # Adding cool names to my planets
      tic = TicSeq.first.last_value
      sleep(1)
      if last_tic != tic
        puts "Starting new Tic"
        last_tic = tic
        Planet.my_planets.not_home.each_with_index do |planet, i|
          planet.update_attribute('name', Planet.get_new_planet_name(i.to_s))
        end

        Planet.my_planets.each do |planet|
          begin
	   conquer_planet(planet)
          rescue Exception => e
            # Row locking was occurring on mass upgrading
            puts e.message
          end
        end

        # Ships that are out of fuel that haven't reached their destination
        puts "Checking for ships travelling that are out of fuel"
        MyShip.where("not location ~= destination AND current_fuel < max_speed").each do |explorer|
          puts "Refueling ship #{explorer.name}"
          explorer.refuel_ship
        end
      end
    end
  end

  # @param [Object] planet
  def conquer_planet(planet)
    if planet.ships.size < planet.mine_limit && MyShip.count < 2001
      puts "This planet needs ships"
      ((@my_player.balance + @my_player.fuel_reserve) / 1000).times do
        @my_player.convert_fuel_to_money(1000) if @my_player.balance < 1000

        # If you can build another miner at home, do so
        ship = planet.ships.create(
          :name => "#{planet.name}-miner",
          :prospecting => 20,
          :attack => 0,
          :defense => 0,
          :engineering => 0,
          :location => planet.location
        )

        if ship.id?
          ship = ship.reload
          ship.update_attributes(:action => "MINE", :action_target_id => planet.id)
        end

        puts "Created a ship for #{planet.name}"
        break if planet.ships.size >= 30
      end
    else
      puts "#{planet.name} has maxed out on miners"
      # If I have the same amount of miners on my home planet as the limit allows for, it makes more sense to upgrade the ships instead
      unless planet.ships.average("prospecting+engineering+defense+attack") == @max_ship_skill
        planet.ships.where("(prospecting+engineering+defense+attack) < ?", @max_ship_skill).each do |ship|
          begin
            skill_remaining = @max_ship_skill - (ship.prospecting + ship.engineering + ship.defense + ship.attack)
            upgrade_amount = skill_remaining < 100 ? skill_remaining.to_i : 100
            puts "upgrading ship skill by #{upgrade_amount}"

            # Balance wasn't reloading for player after purchase
            # TODO: Remove requirement to reload player
            @my_player = MyPlayer.first
            @my_player.convert_fuel_to_money(upgrade_amount * 25) if @my_player.balance < (upgrade_amount * 25)
            ship.upgrade('PROSPECTING', upgrade_amount)
            ship.update_attribute("name", "#{planet.name}-miner")
          rescue Exception => e
            # Row locking was occurring on mass upgrading
            puts e.message
          end
        end
      end

      # Balance wasn't reloading for player after purchase
      # TODO: Remove requirement to reload player
      @my_player = MyPlayer.first

      # Our miners are getting maxed, lets build a ship and send him to the next closest planet
      closest_planet = planet.closest_planet
      if MyShip.where("destination ~= POINT(?)", closest_planet.location).empty? && (@my_player.total_resources >= 1000 + (total_cost = closest_planet.distance.to_f * 2 + 360))
        puts "Expanding to the closest planet from #{planet.name} to #{closest_planet.name} which is #{closest_planet.distance} light years away"
        explorer_ship = nil
        if MyShip.count < 2001
          @my_player.convert_fuel_to_money(1000) if @my_player.balance < 1000
          explorer_ship = planet.ships.create(
            :name => "#{USERNAME}-#{closest_planet.name}-explorer",
            :prospecting => 20,
            :attack => 0,
            :defense => 0,
            :engineering => 0,
            :location => planet.location
          )
        else
          if planet.ships.size > 1
            explorer_ship = planet.ships.first
            explorer_ship.update_attribute("name", "#{USERNAME}-#{closest_planet.name}-explorer")
          end
        end

        if explorer_ship && explorer_ship.id?
          explorer_ship = explorer_ship.reload
          explorer_ship.update_attributes(:action => "MINE", :action_target_id => closest_planet.id)
          @my_player.convert_fuel_to_money((total_cost - @my_player.balance).ceil) if @my_player.balance < total_cost
          #upgrade_amount = closest_planet.distance.to_f.ceil > @max_ship_fuel - ship.max_fuel ? @max_ship_fuel - ship.max_fuel : closest_planet.distance.to_f.ceil
          explorer_ship.upgrade("MAX_FUEL", (@max_ship_fuel - explorer_ship.current_fuel).ceil)
          explorer_ship.upgrade("MAX_SPEED", (@max_ship_fuel / 2).to_i)
          explorer_ship.refuel_ship
          explorer_ship = ship.reload
          puts "Sending ship #{explorer_ship.name}"
          explorer_ship.course_control((closest_planet.distance.to_f / 2).ceil, nil, closest_planet.location)
        end
      end
    end
  end
end

raise "Username and Password Required" unless (ARGV[0] && ARGV[1]) || (ENV['DATABASE_URL'] && ENV['SCHEMAVERSE_USERNAME'])
load('config/initializers/environment.rb')

Schemaverse.new.play




