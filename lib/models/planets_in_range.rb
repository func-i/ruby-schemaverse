class PlanetsInRange < ActiveRecord::Base
  self.table_name = 'planets_in_range'

  belongs_to :ship, :foreign_key => "ship"
  belongs_to :planet, :foreign_key => 'planet'

end