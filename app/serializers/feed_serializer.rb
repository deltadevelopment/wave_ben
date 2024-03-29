class FeedSerializer < ActiveModel::Serializer
  attributes :id, :title, :bucket_type, :drops_count, :visibility

  has_one :user
  has_one :drop

  private

  def drop
    Drop.where(bucket_id: object.id).order(created_at: :desc).first
  end
  
end
