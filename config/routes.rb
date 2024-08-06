Rails.application.routes.draw do
  root 'home#index'
  get "users/sign_up" => "users#new"
  get "about" => "about#index"
  get "users/:id" => "users#show"
  get "users/:id/edit" => "users#edit"
  put "users/:id" => "users#update"
  post "users/:id" => "users#create"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
