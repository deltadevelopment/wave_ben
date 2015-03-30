Rails.application.routes.draw do

  # User Routes
  post '/register' => 'users#create'


end
