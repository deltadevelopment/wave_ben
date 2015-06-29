class HashtagSerializer < ActiveModel::Serializer
  attributes :id, :tag_string, :count
end 
