class VotePolicy < ApplicationPolicy

  def destroy?
    user_is_owner?
  end

end
