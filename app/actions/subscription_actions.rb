class SubscriptionActions

  def initialize(subscription: nil, param: nil)
    @subscription = subscription
    @param = param
  end

  def create!
    
    record_exists = Subscription.exists?(
      user_id:        @subscription.user_id,
      subscribee_id:  @subscription.subscribee_id
    )

    if record_exists
      return @subscription
    else
      if @subscription.save
        GenerateRippleJob.perform_later(
          @subscription, 'create', @subscription.user
        )
      end
    end

    @subscription

  end

end
