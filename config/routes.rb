Rails.application.routes.draw do
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
   # Driver login and logout routes
   get 'drivers/login', to: 'drivers#new', as: :new_driver_session
   post 'drivers/login', to: 'drivers#login', as: :driver_session
   delete 'drivers/logout', to: 'drivers#destroy', as: :destroy_driver_session

    # Driver signup route
    get 'drivers/signup', to: 'drivers#signup', as: :new_driver_registration
    post 'drivers', to: 'drivers#create', as: :drivers


end
