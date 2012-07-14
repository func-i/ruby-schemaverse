# Finds all ships in range of a ship
#   @my_ship = MyShip.first
#   @my_ship.ships_in_range
class ShipsInRange < ActiveRecord::Base
  self.table_name = 'ships_in_range'

  belongs_to :ship, :foreign_key => "ship_in_range_of"

end