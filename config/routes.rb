Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  namespace :api do
    namespace :v1 do
      resources :orders, only: [:create, :index]
      resources :items, only: [:create, :update, :destroy, :index, :show]
      resources :users, only: [:index]
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users, path: '', path_names: {
    sign_in: '/user/login',
    sign_out: '/user/logout',
    registration: '/user/register'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    put '/user/update', to: 'users/registrations#update', as: :update_user_registration
    put '/user/update/:id', to: 'users/registrations#update_profile', as: :update_user_profile
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
