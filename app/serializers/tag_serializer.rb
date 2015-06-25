class TagSerializer < ActiveModel::Serializer
  attributes :id, :taggee_id, :taggee_type, :taggable_id, :taggable_type, :user, :taggee

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
