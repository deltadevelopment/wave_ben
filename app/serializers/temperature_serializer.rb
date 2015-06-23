class TemperatureSerializer < ActiveModel::Serializer
  attributes :id, :drop_id, :bucket_id, :temperature
  
  has_one :user
end
