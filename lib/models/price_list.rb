# Used to store the prices of upgrades, ships and other purchasable items
#
#     PriceList.ship
#     PriceList.attack
#     PriceList.schemaverse <-- Throws NoMethod error
class PriceList < ActiveRecord::Base
  self.table_name = 'price_list'

  scope :with_code, lambda{|code|
    where(:code => code)
  }

  # Look for a column in the price_list table
  # @return [String] If the column exists in the price_list table, return the cost column
  def self.method_missing(m)
    var = PriceList.with_code(m.to_s.upcase).first
    if var
      return var.cost
    else
      super
    end
  end
end