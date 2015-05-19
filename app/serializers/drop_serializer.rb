class DropSerializer < ActiveModel::Serializer
  attributes :id, :media_key, :temperature, :media_type, :thumbnail_key

  has_one :user
end
