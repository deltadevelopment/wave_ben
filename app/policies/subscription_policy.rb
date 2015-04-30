class SubscriptionPolicy < ApplicationPolicy

  def create?
    is_logged_in?    
  end

  def destroy?
    user_is_user?
  end

end
