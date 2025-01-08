require 'net/http'
require 'json'
class TrucksController < ApplicationController
  before_action :authorize_driver, except: [:index]
  def index
    @driver = current_driver
    # Corrected query to join drivers_trucks and trucks, ensuring truck_id is included
    @assigned_trucks = @driver.drivers_trucks.joins(:truck)
                                         .select('drivers_trucks.assigned_date, trucks.name, trucks.truck_type, drivers_trucks.truck_id')

    # Fetching all trucks from the API
    url = URI('https://api-task-bfrm.onrender.com/api/v1/trucks')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https'
    request = Net::HTTP::Get.new(url)
    request['API_KEY'] = 'illa-trucks-2023'
    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      trucks_data = JSON.parse(response.body)
      trucks_data.each do |truck_data|
        Truck.find_or_create_by(name: truck_data['name']) do |truck|
          truck.truck_type = truck_data['truck_type']
        end
      end
      @trucks = Truck.all
    else
      flash[:alert] = 'Unexpected API response structure.'
      @trucks = Truck.all
    end

    @driver_token = session[:driver_token] || params[:driver_token]
  end


  def assigned_trucks
    trucks = current_driver.trucks
    render json: { data: trucks.map { |truck| format_truck(truck) } }
  end

  def assign
    driver = current_driver
    if driver.nil?
      redirect_to trucks_path, alert: 'Invalid or missing driver token.'
      return
    end

    truck_id = params[:truck_id]
    assigned_date = params[:assigned_date] # Get the assigned date from the form
    if truck_id.present? && assigned_date.present?
      truck = Truck.find_by(id: truck_id)
      if truck
        # Ensure the driver has the truck and set the assigned date
        driver_truck = DriversTruck.find_or_initialize_by(driver_id: driver.id, truck_id: truck.id)
        driver_truck.assigned_date = assigned_date # Set the assigned date directly
        if driver_truck.save
          redirect_to trucks_path, notice: "Truck #{truck.name} successfully assigned to #{driver.email}."
        else
          redirect_to trucks_path, alert: "Failed to assign the truck."
        end
      else
        redirect_to trucks_path, alert: 'Truck not found.'
      end
    else
      redirect_to trucks_path, alert: 'Truck ID or assigned date is missing.'
    end
  end






  private

  def format_truck(truck)
    {
      id: truck.id,
      name: truck.name,
      truck_type: truck.truck_type,
      assigned_at: truck.created_at
    }
  end






  def authorize_driver
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_driver
  end
end
