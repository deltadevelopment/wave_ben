class VoteSerializer < ActiveModel::Serializer
  attributes :id, :drop_id, :bucket_id, :vote
  
  has_one :user
end
