Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  resources :users
  resources :microposts,          only: [:create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  # Set the root of the webserver 
  root 'static_pages#home'

  # Set static page routes
  get     '/about',   to: 'static_pages#about'
  get     '/help',    to: 'static_pages#help'
  get     '/signup',  to: 'users#new'
  post    '/signup',  to: 'users#create'
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'
end
