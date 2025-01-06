require 'net/http'
require 'json'
class TrucksController < ApplicationController
  before_action :authorize_driver, except: [:index]
  def index
    # Base URL for the API endpoint
    url = URI('https://api-task-bfrm.onrender.com/api/v1/trucks')

    # Initialize HTTP request object
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https'

    # Initialize the request and set headers
    request = Net::HTTP::Get.new(url)
    request['API_KEY'] = 'illa-trucks-2023'  # Add the API key here

    # Send the request
    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      trucks_data = JSON.parse(response.body)
      @trucks = trucks_data

      # Pagination headers from the response
      @current_page = response['current-page']
      @page_items = response['page-items']
      @total_count = response['total-count']
      @total_pages = response['total-pages']
    else
      @trucks = []
      @current_page = @page_items = @total_count = @total_pages = 0
    end
  end

  def assign
    truck = Truck.find(params[:id])
    current_driver.trucks << truck unless current_driver.trucks.include?(truck)
    render json: { message: "Truck assigned successfully" }, status: :ok
  end

  def assigned_trucks
    trucks = current_driver.trucks
    render json: { data: trucks.map { |truck| format_truck(truck) } }
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

  def current_driver
    @current_driver ||= Driver.find(JsonWebToken.decode(request.headers['Authorization'])[:driver_id])
  end

  def authorize_driver
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_driver
  end
end
