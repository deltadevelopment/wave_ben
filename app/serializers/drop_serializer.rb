class DropSerializer < ActiveModel::Serializer
  attributes :id, :media_key, :temperature, :media_type, :media_url, :thumbnail_key, :thumbnail_url, :bucket_id, :drop_id, :originator, :most_votes, :most_votes_count

  has_one :user

  def most_votes
    object.vote_zero_count > object.vote_one_count ?
      0 : 1
  end

  def most_votes_count
    object.vote_zero_count > object.vote_one_count ?
      object.vote_zero_count : object.vote_one_count
  end

  def originator
    if object.drop_id?
      # return object.original_drop.user.remove_unsafe_keys
      return UserSerializer.new(object.original_drop.user, root: false)
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
