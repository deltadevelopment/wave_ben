class DropSerializer < ActiveModel::Serializer
  attributes :id, :media_key, :temperature, :media_type, :media_url, :thumbnail_key, :thumbnail_url, :bucket_id, :drop_id, :originator

  has_one :user

  def originator
    if object.drop_id?
      return object.original_drop.user.remove_unsafe_keys
    end
    nil
  end

  def media_url
    object.generate_download_uri(media: media_key)
  end

  def thumbnail_url
    if object.media_type == 1
      object.generate_download_uri(thumbnail: object.thumbnail_key)
    end
  end
end
