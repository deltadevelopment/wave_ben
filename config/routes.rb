Rails.application.routes.draw do

  # User routes
  post '/register' => 'users#create'
  delete '/user/:id' => 'users#destroy'
  put 'user/:id' => 'users#update'

  # Session routes
  post '/login' => 'user_sessions#create'
  delete '/login' => 'user_sessions#destroy'

  # Bucket routes
  post '/bucket' => 'buckets#create'
  put '/bucket/:id' => 'buckets#update'
  delete '/bucket/:id' => 'buckets#destroy'

  # Drop routes
  post '/bucket/:id/drop/' => 'drops#create'
  delete '/drop/:drop_id' => 'drops#create'
  post '/drop/generate_upload_url' => 'drops#generate_upload_url'

  # Following routes
  post 'user/:user_id/follow/:followee_id' => 'followings#create_or_request'
  delete 'user/:user_id/follow/:followee_id' => 'followings#create_or_request'

  # Resque routes
  get 'jobs' => 'jobs#list'

  mount Resque::Server, :at => "/resque" 

end
