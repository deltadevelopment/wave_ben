require 'rails_helper'

class TagPolicy < ApplicationPolicy

  def create?
    if record.taggable.locked?
      if record.taggable.visibility == 'taggees'
        user_is_owner?  
      else
        user_is_owner_or_taggee? 
      end
    else
      if record.taggable.visibility == 'taggees'
        user_is_owner_or_taggee?
      else
        is_logged_in?
      end
    end
  end

  def destroy?
    user_is_owner?
  end

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
