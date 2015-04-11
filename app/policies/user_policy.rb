class UserPolicy < ApplicationPolicy
  
  def update?
    user_is_user?
  end

  def destroy?
    user_is_user?
  end

end
