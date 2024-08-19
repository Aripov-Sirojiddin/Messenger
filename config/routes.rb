Rails.application.routes.draw do
  root 'home#index'

  get "users/sign_up" => "users#new"
  get "about" => "about#index"
  get "users/delete/:id" => "users#delete", as: "delete_user"
  delete "/logout" => "sessions#destroy"
  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  resources :users

  resources :account_activations, only: [:edit]

end
