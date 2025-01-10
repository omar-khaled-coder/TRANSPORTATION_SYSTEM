require "test_helper"

class TruckTest < ActiveSupport::TestCase
  def setup
    @truck = Truck.new(name: "Truck 1", truck_type: "Heavy")
  end

  test "should be valid with valid attributes" do
    assert @truck.valid?
  end

  test "should require a name" do
    @truck.name = ""
    assert_not @truck.valid?
  end

  test "should require a truck type" do
    @truck.truck_type = ""
    assert_not @truck.valid?
  end
end
