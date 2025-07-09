Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "/api/v1/auth", controllers: {
    registrations: "api/v1/auth/registrations",
    sessions: "api/v1/auth/sessions",
    passwords: "api/v1/auth/passwords"
  }

  namespace :api do
    namespace :v1 do
      # Define your API routes here
      # Example: resources :posts
      # resources :posts, only: [:index, :show, :create, :update, :destroy]
      resources :users, only: [ :index, :show ] do
        collection do
          get :me
        end
      end
      resources :events, only: [ :index, :show, :create, :update, :destroy ] do
        resources :event_teams, only: [ :index, :update, :destroy ] do
          resources :event_participants, only: [ :index, :create, :destroy ]
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
