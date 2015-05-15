class DropSerializer < ActiveModel::Serializer
  attributes :id, :media_key, :temperature, :media_type

  has_one :user
end
