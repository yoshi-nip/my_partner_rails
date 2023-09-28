Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
      }
      resources :day_articles, only: [:index, :create, :show, :update, :destroy]
      resources :monthly_articles, only: [:index, :create, :show, :update, :destroy]
      resources :monthly_promises, only: [:index, :create, :show, :update, :destroy]
      resources :habits, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
