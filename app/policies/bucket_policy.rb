class BucketPolicy < ApplicationPolicy

  def show?
    bucket_is_visible?
  end
  
  def create?
    is_logged_in? 
  end

  def update?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end

  def buckets_for_user?
    user_is_owner? 
  end

  def watch?
    bucket_is_visible?
  end

  private

  def bucket_is_visible?
    if record.taggees?
      user_is_owner_or_taggee?      
    else
      true
    end
  end

  def user_is_taggee?
    record.tags.pluck(:taggee_id).include?(user.id)
  end

  def user_is_owner?
    record.user_id == user.id
  end

  def user_is_owner_or_taggee?
    user_is_owner? || user_is_taggee?
  end

end
