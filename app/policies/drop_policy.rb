class DropPolicy < ApplicationPolicy

  def create?
    if record.bucket.user?
      user_is_bucket_owner?
    else
      if record.bucket.visibility == 'taggees'
        user_is_bucket_owner_or_taggee?
      else
        is_logged_in?
      end
    end
  end

  def generate_upload_url?
    is_logged_in?    
  end

  def destroy?
    user_is_bucket_owner? || user_is_owner?
  end

  def redrop?
    is_logged_in?
  end

  def create_vote?
    if record.bucket.visibility == 'taggees'
      user_is_bucket_owner_or_taggee?
    else
      is_logged_in?
    end
  end

  def list_votes?
    if record.bucket.visibility == 'taggees'
      user_is_bucket_owner_or_taggee?
    else
      is_logged_in?
    end
  end

  private

  def user_can_see_bucket?
  end

  def user_is_taggee?
    record.bucket.tags.pluck(:taggee_id).include?(user.id)
  end

  def user_is_bucket_owner?
    record.bucket.user_id == user.id
  end

  def user_is_owner?
    record.user_id == user.id
  end

  def user_is_bucket_owner_or_taggee?
    user_is_bucket_owner? || user_is_taggee?
  end

end
