class DropPolicy < ApplicationPolicy

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
    user_is_owner_of_drop_or_bucket?
  end
  
  def user_is_owner_of_drop_or_bucket?
    false
  end

  def generate_upload_url?
    is_logged_in?    
  end

end
