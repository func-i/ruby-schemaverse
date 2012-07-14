# Finds all planets in range of a ship
#     @my_ship = MyShip.first
#     @my_ship.planets_in_range
class PlanetsInRange < ActiveRecord::Base
  self.table_name = 'planets_in_range'

  belongs_to :ship, :foreign_key => "ship"
  belongs_to :planet, :foreign_key => 'planet'

end