class MyPlayer < ActiveRecord::Base
  self.table_name = 'my_player'  

  def convert_fuel_to_money(amount)
    self.class.select("CONVERT_RESOURCE('FUEL', #{amount})").where(:id => self.id).first
  end

  def convert_money_to_fuel(amount)
    self.class.select("CONVERT_RESOURCE('MONEY', #{amount})").where(:id => self.id).first
  end

  def total_resources
    self.balance + self.fuel_reserve
  end

end