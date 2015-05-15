class FeedSerializer < ActiveModel::Serializer
  attributes :id, :title, :bucket_type, :drops_count

  has_many :drops
  has_one :user
end

class DropSerializer < ActiveModel::Serializer
  attributes :id, :temperature, :media_key

  has_one :user
end

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username
end
