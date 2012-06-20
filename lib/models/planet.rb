class Planet < ActiveRecord::Base 
  self.primary_key = 'id'
  scope :my_planets, where(:conqueror_id => MyPlayer.first.id)
end