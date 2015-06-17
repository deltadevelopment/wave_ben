class SubscriptionSerializer < ActiveModel::Serializer

  attributes :id, :user_id, :subscribee_id, :reciprocal

  def reciprocal
    if Subscription.where(
      user_id: object.subscribee_id, subscribee_id: object.user_id
    ).take
      return true
    end
    false
  end
  
end
