Rails.application.routes.draw do

  # User Routes
  post '/register' => 'users#create'

  # Session routes
  post '/login' => 'sessions#create'


end
