class Planet < ActiveRecord::Base 
  self.primary_key = 'id'

  scope :my_planets, where(:conqueror_id => MyPlayer.first.id)
  scope :with_my_ships, :joins => "INNER JOIN my_ships ON planets.location_x = my_ships.location_x AND planets.location_y = my_ships.location_y "

  def self.home
    self.where(:name => self.my_home_name).first
  end

  def self.not_home
    self.where("name <> ?", self.my_home_name)
  end

  def self.my_home_name
    "#{USERNAME}-prime".upcase
  end

  def self.get_new_planet_name
    next_num = (Planet.my_planets.count + 1).to_s
    greek_alpha = %w{ alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu nu xi omicron pi rho sigma tau upsilon phi chi psi omega}
    n = "#{USERNAME}-#{greek_alpha[next_num[0].to_i - 1]}"
    n += "-#{next_num[1..next_num.size]}" if next_num.size > 1
    n.capitalize
  end

  def ships
    MyShip.where(:location_x => self.location_x, :location_y => self.location_y)
  end

  def closest_planet
    #SELECT planets.location, planets.name, planets.id, planets.location<->my_home.location as distance  FROM planets, planets my_home WHERE NOT my_home.location ~= planets.location and my_home.conqueror_id=2599 ORDER by distance ASC LIMIT 10;
    self.class.select("id, name, location, planets.location<->POINT('#{self.location}') as distance").
      where("NOT location ~= POINT(?)", self.location).
      order("distance ASC").first
  end

end