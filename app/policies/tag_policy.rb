class TagPolicy < ApplicationPolicy

  def create?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end
  
  private

  def user_is_taggee?
    record.taggable.tags.pluck(:taggee_id).include?(user.id)
  end

  def user_is_owner?
    record.taggable.user_id == user.id
  end

  def user_is_owner_or_taggee?
    user_is_owner? || user_is_taggee?
  end

end
