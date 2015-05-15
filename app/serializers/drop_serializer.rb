class DropSerializer < ActiveModel::Serializer
  attributes :id, :media_key, :temperature

  has_one :user
end
