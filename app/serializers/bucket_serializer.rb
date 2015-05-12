class BucketSerializer < ActiveModel::Serializer
  attributes :id, :title, :temperature

  has_many :drops
end
