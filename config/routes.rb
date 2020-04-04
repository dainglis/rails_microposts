Rails.application.routes.draw do
  resources :microposts
  resources :users
  
  # Set the root of the webserver to show a list of users
  root 'users#index'
end
