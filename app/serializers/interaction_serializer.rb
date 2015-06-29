class InteractionSerializer < ActiveModel::Serializer
  attributes :id, :topic_id, :topic_type, :user_id, :action

  has_one :topic
end
