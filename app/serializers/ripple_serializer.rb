class RippleSerializer < ActiveModel::Serializer
  attributes :message, :trigger_id, :trigger_type, :triggee_id 
end
