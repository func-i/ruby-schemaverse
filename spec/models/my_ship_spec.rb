require "spec_helper"

describe MyShip do

  describe "Upgrading" do

    before(:each) do
      @my_ship = MyShip.where("(prospecting+engineering+defense+attack) < ?", Functions.get_numeric_variable('MAX_SHIP_SKILL')).first
    end

    it "should update the attribute for the corresponding upgrade" do
      before_attack = @my_ship.attack
      if @my_ship.upgrade("ATTACK", 10)
        @my_ship.attack.should == before_attack + 10
      end
    end
  end

  describe "Moving" do

    before(:each) do
      @my_ship = MyShip.where("NOT location ~= POINT(?)", Planet.home.location).first
    end

    it "should set the speed destination x,y and destination(x,y) with ship_course_control" do
      if @my_ship.course_control(10, nil, Planet.home.location)
        @my_ship.max_speed.should == 10
        @my_ship.destination.should == Planet.home.location
      end
    end

  end

end