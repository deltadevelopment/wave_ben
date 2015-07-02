class SubscriptionActions

  def initialize(subscription: nil, param: nil)
    @subscription = subscription
    @param = param
  end

  def create!
    
    subscription = Subscription.find_or_initialize_by(
      user_id: @subscription.user_id,
      subscribee_id: @subscription.subscribee_id
    )

    if subscription.user_id == subscription.subscribee_id
      subscription.errors.add(
        :user_id,
        "cannot be the same as subscribee_id"
      )
    end

    if subscription.errors.empty? && subscription.save
      InteractionActions.new(
        interaction: Interaction.new(
          user: subscription.user,
          topic: subscription,
          action: "create_subscription"
        )
      ).create!
    end

    subscription

  end

end
