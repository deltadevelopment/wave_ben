class UserSerializer < ActiveModel::Serializer

  attributes :id, :username, :display_name, :subscribers_count
  
end
