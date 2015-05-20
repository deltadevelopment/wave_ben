class FeedController < ApplicationController
#  after_action :verify_authorized

  def show
    subscriptions = Subscription.where(user_id: current_user)

    subscription_ids = []
    subscriptions.each { |f| subscription_ids.push(f.subscribee_id) }

    buckets = Bucket.where("user_id IN (?)", subscription_ids)

    json_response 200,
      success: true,
      message: I18n.t('success.ok'),
      message_id: 'ok',
      data: ActiveModel::ArraySerializer.new(
        buckets,
        each_serializer: FeedSerializer,
        root: "buckets"
      )

  end

end
