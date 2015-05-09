class SubscriptionPolicy < ApplicationPolicy

  def create?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end

end
