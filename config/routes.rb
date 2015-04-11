Rails.application.routes.draw do

  # User Routes
  post '/register' => 'users#create'
  delete '/user/:id' => 'users#destroy'
  put 'user/:id' => 'users#update'

  # Session routes
  post '/login' => 'sessions#create'
  delete '/login' => 'sessions#destroy'


end
