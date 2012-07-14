# The player you have logged in as.  This table contains your username, error_channel, balance, fuel_reserve
# @see https://schemaverse.com/tutorial/tutorial.php?page=MyPlayer
# @see https://schemaverse.com/tutorial/tutorial.php?page=MyResources
class MyPlayer < ActiveRecord::Base
  self.table_name = 'my_player'

  # Converts fuel for the player into money
  # @param [String] amount Amount to convert into money
  # @return [Boolean] Indicates whether the conversion was successful
  def convert_fuel_to_money(amount)
    val = MyPlayer.select("CONVERT_RESOURCE('FUEL', #{amount})").where(:id => self.id).first.attributes

    # Update the player attributes after a successful conversion
    unless val["convert_resource"].blank?
      self.fuel_reserve -= val["convert_resource"].to_i
      self.balance += val["convert_resource"].to_i
    end
  end

  # Converts money for the player into fuel
  # @param [String] amount Amount to convert into fuel
  # @return [Boolean] Indicates whether the conversion was successful
  def convert_money_to_fuel(amount)
    val = self.class.select("CONVERT_RESOURCE('MONEY', #{amount})").where(:id => self.id).first.attributes
    # Update the player attributes after a successful conversion
    unless val["convert_resource"].blank?
      self.balance -= val["convert_resource"].to_i
      self.fuel_reserve += val["convert_resource"].to_i
    end
  end

  # Adds the player's balance and fuel_reserve
  def total_resources
    self.balance + self.fuel_reserve
  end

end