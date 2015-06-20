class RippleSerializer < ActiveModel::Serializer
  attributes :id, :interaction_id, :user_id

  has_one :interaction
end
