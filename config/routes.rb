Rails.application.routes.draw do

  # Feed routes
  get '/feed' => 'feed#show'

  # User routes
  get 'user/generate_upload_url' => 'users#generate_upload_url'
  get 'user/:user_id' => 'users#show'
  post 'register' => 'users#create'
  delete 'user/:user_id' => 'users#destroy'
  put 'user/:user_id' => 'users#update'
  get 'user/:user_id/buckets' => 'buckets#buckets_for_user'

  # Session routes
  post 'login' => 'user_sessions#create'
  delete 'login' => 'user_sessions#destroy'

  # Bucket routes
  get 'bucket/:bucket_id/' => 'buckets#show'
  post 'bucket' => 'buckets#create'
  put 'bucket/:bucket_id' => 'buckets#update'
  delete 'bucket/:bucket_id' => 'buckets#destroy'

  # Drop routes
  post 'bucket/:bucket_id/drop/' => 'drops#create'
  delete 'drop/:drop_id' => 'drops#destroy'
  post 'drop/generate_upload_url' => 'drops#generate_upload_url'

  # Temperature routes
  post 'drop/:drop_id/vote' => 'drops#vote'

  # Subscriber routes
  get 'user/:user_id/subscription/:subscribee_id' => 'subscriptions#show'
  post 'user/:user_id/subscription/:subscribee_id' => 'subscriptions#create'
  delete 'user/:user_id/subscription/:subscribee_id' => 'subscriptions#destroy'

  # Tag routes
  post 'bucket/:bucket_id/tag' => 'tags#create'
  delete 'tag/:tag_id' => 'tags#destroy'

  # Resque routes
  get 'jobs' => 'jobs#list'

  mount Resque::Server, :at => "/resque" 

end
