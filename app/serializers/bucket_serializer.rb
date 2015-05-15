class BucketSerializer < ActiveModel::Serializer
  attributes :id, :title, :bucket_type
  
  has_many :drops
  has_one :user

end
