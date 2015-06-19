class BucketSerializer < ActiveModel::Serializer
  attributes :id, :title, :bucket_type, :drops_count
  
  has_many :drops
  has_one :user

  def drops
    Drop.where(bucket_id: object.id).order(created_at: :desc)
  end
end
