Rails.application.routes.draw do
  get 'sessions/new'
  resources :microposts
  resources :users
  
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
