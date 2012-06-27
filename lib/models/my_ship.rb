class MyShip < ActiveRecord::Base

  self.primary_key = 'id'
  has_many :planets_in_range, :foreign_key => "ship"

  def self.mine_all_planets
    sql = "UPDATE my_ships SET
		  action='MINE',
		  action_target_id=planets_in_range.planet
	   FROM planets_in_range
	   WHERE my_ships.id=planets_in_range.ship;"
    ActiveRecord::Base.connection.update_sql(sql)
  end

  def upgrade(attribute, amount)
    self.class.select("UPGRADE(#{self.id}, #{attribute}, #{amount})").all
  end
  
  def refuel_ship()
    self.class.select("REFUEL_SHIP(#{self.id})").all
  end
  
  def attack(shipID)
    self.class.select("ATTACK(#{self.id}, #{shipID})").all
  end    

  def repair(shipID)
    self.class.select("REPAIR(#{self.id}, #{shipID})").all
  end
  
  def mine(planetID)
    self.class.select("MINE(#{self.id}, #{planetID})").all
  end
  
end