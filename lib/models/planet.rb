class Planet < ActiveRecord::Base 
  self.primary_key = 'id'

  scope :my_planets, where(:conqueror_id => MyPlayer.first.id)
  scope :with_my_ships, :joins => "INNER JOIN my_ships ON planets.location_x = my_ships.location_x AND planets.location_y = my_ships.location_y "
end