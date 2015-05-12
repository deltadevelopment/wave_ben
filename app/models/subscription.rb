class Subscription < ActiveRecord::Base

  belongs_to :user, counter_cache: :subscriptions_count
  belongs_to :subscribee, class_name: 'User', counter_cache: :subscribers_count

end
