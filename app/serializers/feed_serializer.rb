class FeedSerializer < ActiveModel::Serializer
  attributes :id, :title, :bucket_type, :drops_count

  has_one :user
  has_one :drop

  private

  def drop
    Drop.where(bucket_id: object.id).order(created_at: :desc).first
  end
  
end

class DropSerializer < ActiveModel::Serializer
  attributes :id, :temperature, :media_key, :media_url

  has_one :user

  def media_url
    object.generate_download_uri
  end
end

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username
end
