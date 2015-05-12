class DropSerializer < ActiveModel::Serializer
  attributes :id, :media_key, :likes_count

  has_one :user
end
