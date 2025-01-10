require "test_helper"

class DriversControllerTest < ActionDispatch::IntegrationTest
  # test/controllers/drivers_controller_test.rb
test "should signup driver with valid attributes" do
  post drivers_path, params: { driver: { name: "John Doe", email: "john@example.com", password: "password" } }
  follow_redirect! # Follow the redirect to the login page
  assert_response :success
  assert_select "h1", "Login" # Verify that the redirected page shows the login prompt
end


end
