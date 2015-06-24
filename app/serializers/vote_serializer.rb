class VoteSerializer < ActiveModel::Serializer
  attributes :id, :drop_id, :bucket_id, :temperature, :user
  
  has_one :user
end
