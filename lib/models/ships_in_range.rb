class ShipsInRange < ActiveRecord::Base
  self.table_name = 'ships_in_range'

  belongs_to :ship, :foreign_key => "ship_in_range_of"

end