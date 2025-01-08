class DriversController < ApplicationController
  def new
    # This will render the login form (new.html.erb)
  end

  def signup
    # This will render the signup form (signup.html.erb)
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params)
    if @driver.save
      redirect_to new_driver_session_path, notice: 'Signup successful! Please log in.'
    else
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
    @assigned_trucks = Driver.find(current_driver.id).drivers_trucks.includes(:truck).select('drivers_trucks.assigned_date, trucks.name, trucks.truck_type')
  end

  private

  def driver_params
    params.require(:driver).permit(:email, :password, :password_confirmation)
  end
end
