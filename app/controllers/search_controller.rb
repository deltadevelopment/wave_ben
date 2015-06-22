class SearchController < ApplicationController

  def search
    offset = params[:offset].nil? ? 0 : params[:offset]
    case params[:resource_type]
    when "user"
      results = User.where(
        "username LIKE ?", 
        "%#{params[:search_string]}%"
      ).limit(10).offset(params[:offset])
    when "hashtag"
      results = Hashtag.where(
        "tag_string LIKE ?", 
        "%#{params[:search_string]}%"
      ).limit(10).offset(params[:offset])
    else
      raise ActiveRecord::RecordNotFound 
    end

    results.take!

    data = ActiveModel::ArraySerializer.new(
      results,
      each_serializer: 
        results[0].is_a?(User) ? UserSerializer : HashtagSerializer,
      root: "results"
    )

    json_response 200,
      success: true,
      message: I18n.t('success.ok'),
      message_id: 'ok',
      data: data
  end  

end
