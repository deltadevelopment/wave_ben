class FeedController < ApplicationController

  def show
    subscriptions = Subscription.where(user_id: current_user)

    subscription_ids = []
    subscriptions.each { |f| subscription_ids.push(f.subscribee_id) }

    buckets = Bucket.where("user_id IN (?)", subscription_ids)

    render json: buckets, each_serializer: FeedSerializer, root: "buckets"

  end

end
