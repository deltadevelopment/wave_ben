class DropSerializer < ActiveModel::Serializer
  attributes :id, :media_key, :temperature, :media_type, :media_url, :thumbnail_key, :thumbnail_url, :bucket_id, :drop_id, :originator, :most_votes, :total_votes_count, :created_at

  has_one :user

  # Resolving to root drop because of redrops
  def root_drop
  end

  def most_votes
    root_drop = object.drop_id.nil? ? object : object.original_drop

    root_drop.vote_zero_count > root_drop.vote_one_count ?
      0 : 1
  end

  def total_votes_count
    root_drop = object.drop_id.nil? ? object : object.original_drop

    root_drop.vote_zero_count + root_drop.vote_one_count
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
