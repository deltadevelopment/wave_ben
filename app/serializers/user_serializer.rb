class UserSerializer < ActiveModel::Serializer

  attributes :id, :username, :subscribers_count, :profile_picture_url

  def profile_picture_url
    if object.profile_picture_key
      object.generate_download_uri
    else
      nil
    end
  end
  
end
