class Schemaverse
  def initialize
    if Planet.where(:name => Planet.my_home_name).empty?
      Planet.my_planets.first.update_attribute('name', Planet.my_home_name)
    end

    @my_player = MyPlayer.first
    @home = Planet.home
    @max_ship_skill = Functions.get_numeric_variable('MAX_SHIP_SKILL')
  end

  def play
    # Loop is supposed to start here and check TicSeq.last_value

    last_tic = TicSeq.first.last_value


    while true
      # Adding cool names to my planets
      tic = TicSeq.first.last_value
      if tic != last_tic
        last_tic = tic
        Planet.my_planets.not_home.each do |planet|
          planet.update_attribute('name', Planet.get_new_planet_name)
        end

        Planet.my_planets.each do |planet|
          conquer_planet(planet)
        end
      end
    end
  end

  def conquer_planet(planet)
    if planet.ships.size < @home.mine_limit
      ((@my_player.balance + @my_player.fuel_reserve) / 1000).times do
        @my_player.convert_fuel_to_money(1000) if @my_player.balance < 1000

        # If you can build another miner at home, do so
        miner = planet.ships.create(
          :name => "#{planet.name}-miner",
          :action => "MINE",
          :action_target_id => planet.id,
          :prospecting => 20,
          :attack => 0,
          :defense => 0,
          :engineering => 0
        )
        break if planet.ships.size >= 30
      end
    else
      # If I have the same amount of miners on my home planet as the limit allows for, it makes more sense to upgrade the ships instead
      unless planet.ships.average("prospecting+engineering+defense+attack") == @max_ship_skill
        planet.ships.where("(prospecting+engineering+defense+attack) < ?", @max_ship_skill).each do |ship|
          # TODO: convert the proper amount for upgrades
          skill_remaining = @max_ship_skill - (ship.prospecting + ship.engineering + ship.defense + ship.attack)
          upgrade_amount = skill_remaining < 20 ? skill_remaining.to_i : 20
          @my_player.convert_fuel_to_money(upgrade_amount * 25) if @my_player.balance < (upgrade_amount * 25)
          ship.upgrade('PROSPECTING', upgrade_amount)
        end
      end

      # Our miners are getting maxed, lets build a ship and send him to the next closest planet
      closest_planet = planet.closest_planet
      if MyShip.where("destination <> ?", closest_planet.location).empty? && (@my_player.total_resources >= 1000 + (total_cost = closest_planet.distance.to_f * 2 + 360))
        @my_player.convert_fuel_to_money(1000) if @my_player.balance < 1000
        ship = planet.ships.create(
          :name => "#{USERNAME}-#{closest_planet.name}-explorer",
          :action => "MINE",
          :action_target_id => closest_planet.id,
          :prospecting => 20,
          :attack => 0,
          :defense => 0,
          :engineering => 0
        )

        ship = ship.reload
        @my_player.convert_fuel_to_money((total_cost - @my_player.balance).ceil) if @my_player.balance - total_cost
        ship.upgrade("MAX_FUEL", closest_planet.distance.to_f.ceil)
        ship.upgrade("MAX_SPEED", closest_planet.distance.to_f.ceil / 2)
        ship = ship.reload
        ship.course_control((closest_planet.distance.to_f / 2).ceil, nil, closest_planet.location)
      end

    end
  end
end

raise "Username and Password Required" unless ARGV[0] && ARGV[1]
load('config/initializers/schemaverse.rb')

Schemaverse.new.play




