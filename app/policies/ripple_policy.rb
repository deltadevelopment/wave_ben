class RipplePolicy < ApplicationPolicy

  def list?
    user_is_owner?    
  end

  def create?
  end

end
