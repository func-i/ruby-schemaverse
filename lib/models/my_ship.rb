class MyShip < ActiveRecord::Base

  self.primary_key = 'id'
  has_many :planets_in_range, :foreign_key => "ship"
  has_many :ships_in_range, :foreign_key => "ship_in_range_of"

  # Update one of the ships attributes by a certain amount
  # @see https://schemaverse.com/tutorial/tutorial.php?page=ShipUpgrades
  #
  # @param [String] attribute The attribute you want to upgrade, `ATTACK` or `DEFENSE` or `PROSPECTING` or `ENGINEERING` or `MAX_HEALTH` or `MAX_FUEL` or `MAX_SPEED` or `RANGE`
  # @param [String] amount A string or integer with the amount you wish to upgrade the attribute.  The attributes have different upgrade limits.
  #
  # @return [Boolean] Indicates whether or not the upgrade was successful.
  def upgrade(attribute, amount)
    val = self.class.select("UPGRADE(#{self.id}, '#{attribute}', #{amount})").where(:id => self.id).first.attributes
    if val["upgrade"] == 't'
      self.send("#{attribute.downcase}=", self.send("#{attribute.downcase}") + amount)
      return true
    end
    return false
  end

  # Refuel the current ship
  def refuel_ship()
    self.class.select("REFUEL_SHIP(#{self.id})").where(:id => self.id).first
  end

  # Issue an attack on another ship.
  # @param [String] ship_id The id of the ship you want to attack. (This can include this ship)
  def commence_attack(ship_id)
    self.class.select("ATTACK(#{self.id}, #{ship_id})").where(:id => self.id).first
  end

  # Repair another ship
  # @param [String] ship_id The id of the ship you want to repair
  def repair(ship_id)
    self.class.select("REPAIR(#{self.id}, #{ship_id})").where(:id => self.id).first
  end

  # Mine a planet if there enough resources available on that planet.
  # Note: If more of your ships mine a planet than any other player, you will conquer that
  # planet and will be able to build ships at that location.
  # You can access your planets using scope Planet.my_planets
  # @see https://schemaverse.com/tutorial/tutorial.php?page=Action-Mine
  # @param [String] planet_id The id of the planet you wish to mine.
  def mine(planet_id)
    self.class.select("MINE(#{self.id}, #{planet_id})").where(:id => self.id).first
  end

  # A helper for moving your ship. If you set speed and destination, the Schemaverse will calculate how to
  # get your ship to it's destination.  You will only have to refuel it periodically via {#refuel_ship}.
  # @see https://schemaverse.com/tutorial/tutorial.php?page=Movement
  # @param [String] speed The speed you want the ship to travel at
  # @param [String] direction The direction you want to move the ship
  # @param [String] destination The destination of your ship. A string in the format of "(X, Y)".
  def course_control(speed, direction = nil, destination = nil)
    dest = destination.nil? ? "NULL" : "POINT('#{destination}')"
    dir = direction.nil? ? "NULL" : direction
    val = self.class.select("SHIP_COURSE_CONTROL(#{self.id}, #{speed}, #{dir}, #{dest})").where(:id => self.id).first.attributes
    if val["ship_course_control"] == 't'
      self.destination = destination
      self.max_speed = speed
      return true
    end
    return false
  end

end