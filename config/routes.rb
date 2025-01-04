Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  namespace :api do
    namespace :v1 do
      resources :orders, only: [:create, :index]
      resources :items, only: [:create, :update, :destroy, :index, :show]
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Defines the root path route ("/")
  # root "posts#index"
end
