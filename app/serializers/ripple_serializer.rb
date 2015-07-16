class RippleSerializer < ActiveModel::Serializer
    attributes :id, :interaction_id, :user_id, :message, :created_at

  has_one :interaction

  def message
    object.generate_message 
  end
end
