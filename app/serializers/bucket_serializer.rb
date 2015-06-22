class BucketSerializer < ActiveModel::Serializer
  attributes :id, :title, :bucket_type, :drops_count, :watching
  
  has_many :drops
  has_one :user
  
  def watching
    if scope
      object.watchers.any? { |w| w.user_id == scope.id }
    end
  end

  def drops
    Drop.where(bucket_id: object.id).order(created_at: :desc)
  end
end
