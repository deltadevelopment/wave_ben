Rails.application.routes.draw do

  # User routes
  post '/register' => 'users#create'
  delete '/user/:user_id' => 'users#destroy'
  put 'user/:user_id' => 'users#update'

  # Session routes
  post '/login' => 'user_sessions#create'
  delete '/login' => 'user_sessions#destroy'

  # Bucket routes
  post '/bucket' => 'buckets#create'
  put '/bucket/:bucket_id' => 'buckets#update'
  delete '/bucket/:bucket_id' => 'buckets#destroy'

  # Drop routes
  post '/bucket/:bucket_id/drop/' => 'drops#create'
  delete '/drop/:drop_id' => 'drops#destroy'
  post '/drop/generate_upload_url' => 'drops#generate_upload_url'

  # Subscriber routes
  post 'user/:user_id/subscribe/:subscribee_id' => 'subscriptions#create'
  delete 'user/:user_id/subscribe/:subscribee_id' => 'subscriptions#destroy'

  # Tag routes
  post 'bucket/:bucket_id/tag' => 'tags#create'
  delete 'tag/:tag_id' => 'tags#destroy'

  # Resque routes
  get 'jobs' => 'jobs#list'

  mount Resque::Server, :at => "/resque" 

end
