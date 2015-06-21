class RippleSerializer < ActiveModel::Serializer
  attributes :id, :interaction_id, :user_id, :message

  has_one :interaction

  def message
    object.generate_message 
  end
end
