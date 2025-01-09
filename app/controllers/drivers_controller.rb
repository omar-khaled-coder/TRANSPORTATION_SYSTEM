class DriversController < ApplicationController
  before_action :set_driver, only: [:assigned_trucks]

  def new
    # Render the login form (new.html.erb)
  end

  def signup
    # Render the signup form (signup.html.erb)
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params)
    if @driver.save
      redirect_to new_driver_session_path, notice: 'Signup successful! Please log in.'
    else
      # Flash the error messages and render the signup page again
      flash[:alert] = @driver.errors.full_messages.join(', ')
      render :signup
    end
  end

  def login
    driver = Driver.find_by(email: params[:email])
    if driver&.authenticate(params[:password])
      # Generate a token for API purposes (if needed)
      token = JsonWebToken.encode({ driver_id: driver.id })

      # Save the driver ID in the session for a web-based flow
      session[:driver_id] = driver.id

      redirect_to root_path, notice: 'Login successful!'
    else
      flash[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session.delete(:driver_id)  # Clear the session
    redirect_to root_path, notice: 'Logged out successfully'
  end

  def assigned_trucks
    # Get the trucks and assigned dates for the current driver
    @assigned_trucks = @driver.drivers_trucks.includes(:truck).select('drivers_trucks.assigned_date, trucks.name, trucks.truck_type')
  end

  private

  def set_driver
    # Fetch the driver based on the current session or driver ID
    @driver = Driver.find(session[:driver_id])
  end

  def driver_params
    params.require(:driver).permit(:email, :password, :password_confirmation)
  end
end
