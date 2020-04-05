Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/help'
  resources :microposts
  resources :users
  
  # Set the root of the webserver to show a list of users
  root 'users#index'
end
