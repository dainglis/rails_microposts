Rails.application.routes.draw do
  resources :microposts
  resources :users
  
  # Set the root of the webserver 
  root 'static_pages#home'

  get '/about', to: 'static_pages#about'
  get '/help', to: 'static_pages#help'
end
