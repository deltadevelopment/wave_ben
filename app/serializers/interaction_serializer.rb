class InteractionSerializer < ActiveModel::Serializer
  attributes :id, :topic_id, :topic_type, :user_id, :action, :created_at

  has_one :topic
  has_one :user
end
