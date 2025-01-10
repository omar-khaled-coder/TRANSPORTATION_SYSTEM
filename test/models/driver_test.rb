require "test_helper"

class DriverTest < ActiveSupport::TestCase
  def setup
    @driver = Driver.new(email: "driver@example.com", password: "password")
  end

  test "should be valid with valid attributes" do
    assert @driver.valid?
  end

  test "should require an email" do
    @driver.email = ""
    assert_not @driver.valid?
  end

  test "should require a password to be present" do
    @driver.password = nil
    assert_not @driver.valid?, "Driver should be invalid without a password"
  end

  test "should have unique email" do
    duplicate_driver = @driver.dup
    @driver.save
    assert_not duplicate_driver.valid?
  end
end
