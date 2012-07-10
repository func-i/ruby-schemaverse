require "spec_helper"

describe MyPlayer do

  before(:each) do
    @my_player = MyPlayer.first
  end

  it "should have the same username as USERNAME"do
    @my_player.username.should == USERNAME
  end

end