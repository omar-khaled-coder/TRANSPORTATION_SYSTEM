class FetchTrucksWorker
  # Include Sidekiq Worker to enable background processing of the 'perform' method
  include Sidekiq::Worker

  def perform
    # API key used for authenticating the request to the trucks API
    api_key = 'illa-trucks-2023'

    # Base URL of the API where the trucks data is fetched from
    url = 'https://api-task-bfrm.onrender.com/api/v1/trucks'

    # Initialize the current page for pagination (starts at 1)
    current_page = 1

    # Start a loop to fetch truck data page by page
    loop do
      # Fetch data from the API for the current page, with the API key passed in the headers
      response = Faraday.get(url, { page: current_page }, { 'API_KEY' => api_key })

      # Parse the response body as JSON to access the truck data
      trucks = JSON.parse(response.body)

      # Iterate through each truck in the response
      trucks.each do |truck|
        # Find an existing truck by name and type, or create a new one if it doesn't exist
        Truck.find_or_create_by(name: truck['name'], truck_type: truck['truck_type'])
      end

      # If the current page number is equal to the total number of pages, exit the loop
      # This indicates that we've processed all available truck data
      break if response.headers['current-page'].to_i == response.headers['total-pages'].to_i

      # Increment the current page to fetch the next set of trucks
      current_page += 1
    end
  end
end
