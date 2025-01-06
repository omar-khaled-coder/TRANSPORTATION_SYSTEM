# app/workers/fetch_trucks_worker.rb
class FetchTrucksWorker
  include Sidekiq::Worker

  def perform
    api_key = 'illa-trucks-2023'
    url = 'https://api-task-bfrm.onrender.com/api/v1/trucks'
    current_page = 1

    loop do
      response = Faraday.get(url, { page: current_page }, { 'API_KEY' => api_key })
      trucks = JSON.parse(response.body)

      trucks.each do |truck|
        Truck.find_or_create_by(name: truck['name'], truck_type: truck['truck_type'])
      end

      # Stop if we reached the last page
      break if response.headers['current-page'].to_i == response.headers['total-pages'].to_i

      current_page += 1
    end
  end
end
