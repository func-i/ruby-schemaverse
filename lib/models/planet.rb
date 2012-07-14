# @see https://schemaverse.com/tutorial/tutorial.php?page=PlanetDetails
class Planet < ActiveRecord::Base
  self.primary_key = 'id'

  scope :my_planets, where(:conqueror_id => MyPlayer.first.id)
  scope :with_my_ships, :joins => "INNER JOIN my_ships ON planets.location_x = my_ships.location_x AND planets.location_y = my_ships.location_y "

  # Finds the planet with the name that matches the return value from {Planet#my_home_name}
  # @return [Planet] Your home planet
  def self.home
    self.where(:name => self.my_home_name).first
  end

  # All planets that are not your home planet.
  # Home planet's name is determined by {Planet#my_home_name}
  # @return [Array] An ActiveRecord scope which can be used to chain finders.
  def self.not_home
    self.where("name <> ?", self.my_home_name)
  end

  # Set a default name for your home planet
  # @return [String] Your home planet's name
  def self.my_home_name
    "#{USERNAME}-prime".upcase
  end

  # Get a new name for a planet
  # This is just me messing around.  Thought it would be kind of cool to have names for all my planets.
  # @param [Integer] next_num The next sequential planet number
  # @return [String] A string with the name for a new planet
  def self.get_new_planet_name(next_num = nil)
    next_num ||= (Planet.my_planets.count + 1).to_s
    greek_alpha = %w{ alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu nu xi omicron pi rho sigma tau upsilon phi chi psi omega}
    n = "#{USERNAME}-#{greek_alpha[next_num[0].to_i - 1]}"
    n += "-#{next_num[1..next_num.size]}" if next_num.size > 1
    n.capitalize
  end

  # A scope that finds ships with a location at this planet
  # @return [Array] ActiveRecord scope that can be used with additional finders or iterated through
  def ships
    MyShip.where("location ~= POINT(?)", self.location)
  end

  # Find the closest planet to this planet.  It will look for planets that are close via distance
  # and that do not have a ship travelling to that location.  This is helpful for expanding to
  # new planets that you have not conquered or are travelling to.
  # @return [Planet] The closest planet that you do not own or are travelling to.
  def closest_planet
    finder = self.class.select("id, name, location, planets.location<->POINT('#{self.location}') as distance")
    self.class.my_planets.each do |p|
      finder = finder.where("NOT location ~= POINT(?)", p.location)
    end
    finder.order("distance ASC").first
  end

end