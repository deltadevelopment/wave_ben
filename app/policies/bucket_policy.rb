class BucketPolicy < ApplicationPolicy
  
  def create?
    is_logged_in? 
  end

  def update?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end

end
