class SubscriptionPolicy < ApplicationPolicy

  def show?
    user_is_owner?  
  end 

  def create?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end

end
