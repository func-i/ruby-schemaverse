class MyPlayer < ActiveRecord::Base
  self.table_name = 'my_player'

  def convert_fuel_to_money(amount)
    val = MyPlayer.select("CONVERT_RESOURCE('FUEL', #{amount})").where(:id => self.id).first.attributes

    # Update the player attributes after a successful conversion
    unless val["convert_resource"].blank?
      self.fuel_reserve -= val["convert_resource"].to_i
      self.balance += val["convert_resource"].to_i
    end
  end

  def convert_money_to_fuel(amount)
    val = self.class.select("CONVERT_RESOURCE('MONEY', #{amount})").where(:id => self.id).first.attributes
    # Update the player attributes after a successful conversion
    unless val["convert_resource"].blank?
      self.balance -= val["convert_resource"].to_i
      self.fuel_reserve += val["convert_resource"].to_i
    end
  end

  def total_resources
    self.balance + self.fuel_reserve
  end

end