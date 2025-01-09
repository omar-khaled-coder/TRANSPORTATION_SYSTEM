require 'sidekiq/web'
Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'
  root to: "pages#home"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Driver login and logout routes
  get 'drivers/login', to: 'drivers#new', as: :new_driver_session
  post 'drivers/login', to: 'drivers#login', as: :driver_session
  delete 'drivers/logout', to: 'drivers#destroy', as: :destroy_driver_session

  # Driver signup route
  get 'drivers/signup', to: 'drivers#signup', as: :new_driver_registration
  post 'drivers', to: 'drivers#create', as: :drivers

  # Trucks routes
  resources :trucks, only: [:index] do
    post 'assign', on: :member
  end

  get 'driver_trucks', to: 'trucks#driver_trucks', as: 'driver_trucks'
end
