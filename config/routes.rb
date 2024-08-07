Rails.application.routes.draw do
  root 'sessions#new'

  get "users/sign_up" => "users#new"
  get "about" => "about#index"

  delete "/logout" => "sessions#destroy"
  get "/login" => "sessions#new"
  post "/login" => "sessions#create"

  resources :users

  get "up" => "rails/health#show", as: :rails_health_check

end
