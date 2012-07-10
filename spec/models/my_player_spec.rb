require "spec_helper"

describe MyPlayer do

  before(:each) do
    @my_player = MyPlayer.first
  end

  it "should have the same username as USERNAME"do
    @my_player.username.should == USERNAME
  end

  it "should convert fuel to money" do
    original_fuel, original_money = @my_player.fuel_reserve, @my_player.balance
    @my_player.convert_fuel_to_money(100)
    @my_player.fuel_reserve.should == original_fuel - 100
    @my_player.balance.should == original_money + 100
  end

  it "should convert money to fuel" do
    original_fuel, original_money = @my_player.fuel_reserve, @my_player.balance
    @my_player.convert_money_to_fuel(100)
    @my_player.balance.should == original_money - 100
    @my_player.fuel_reserve.should == original_fuel + 100
  end


end