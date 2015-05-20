class DropSerializer < ActiveModel::Serializer
  attributes :id, :media_key, :temperature, :media_type, :thumbnail_key, :media_url

  has_one :user

  def media_url
    object.generate_download_uri
  end
end
