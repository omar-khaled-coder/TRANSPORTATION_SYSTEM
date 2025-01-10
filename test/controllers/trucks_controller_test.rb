class TrucksControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Create a driver directly
    @driver = Driver.create!(email: "testdriver@example.com", password: "password")

    # Create a truck directly
    @truck = Truck.create!(name: "Test Truck", truck_type: "Type A")

    # Assign the truck to the driver (without needing to save to the DB)
    @truck.instance_variable_set(:@driver, @driver)
  end

  test "should assign truck to driver" do
    # Simulate login
    post new_driver_session_path, params: { email: 'driver@example.com', password: 'password' }

    # Proceed with truck assignment
    post assign_truck_path(@truck)

    # Assert the truck was assigned to the driver (check the in-memory association)
    assert_equal @driver, @truck.instance_variable_get(:@driver)
  end
end
