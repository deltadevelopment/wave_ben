class RipplesController < ApplicationController

  def list
    ripples = Ripple.where(user: current_user)

    authorize ripples.take!
  
    json_response 200,
      success: true,
      message: I18n.t('success.ok'),
      message_id: 'ok',
      data: ActiveModel::ArraySerializer.new(
      ripples,
        each_serializer: RippleSerializer,
        root: "ripples"
      )
  end

end
