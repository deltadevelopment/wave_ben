class TagSerializer < ActiveModel::Serializer
  attributes :id, :taggee_id, :taggee_type, :taggable_id, :taggable_type, :user, :taggee

  has_one :taggable

  def user
    return UserSerializer.new(object.taggable.user, root: false)
    nil
  end

  def taggee
    if object.taggee_type == "User"
      return UserSerializer.new(object.taggee, root: false)
    end
    nil
  end

  def watching
    if scope
      object.watchers.any? { |w| w.user_id == scope.id }
    end
  end

  def drops
    Drop.where(bucket_id: object.id).order(created_at: :desc)
  end

end

class BucketSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_one :drop

  def drop
    Drop.where(bucket_id: object.id).order(created_at: :desc).first
  end
end
