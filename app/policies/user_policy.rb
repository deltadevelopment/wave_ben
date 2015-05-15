class UserPolicy < ApplicationPolicy

  def show?
    is_logged_in?
  end
  
  def update?
    user_is_user?
  end

  def destroy?
    user_is_user?
  end

end
