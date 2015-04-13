Rails.application.routes.draw do

  # User routes
  post '/register' => 'users#create'
  delete '/user/:id' => 'users#destroy'
  put 'user/:id' => 'users#update'

  # Session routes
  post '/login' => 'user_sessions#create'
  delete '/login' => 'user_sessions#destroy'

  # Resque routes
  get 'jobs' => 'jobs#list'

  mount Resque::Server, :at => "/resque" 

end
