Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'home#index'

  get "users/sign_up" => "users#new"
  get "about" => "about#index"
  get "users/delete/:id" => "users#delete", as: "delete_user"
  delete "/logout" => "sessions#destroy"
  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
