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

  def create
    ripple = Ripple.new(create_params)

    check_valid_authorization

    ripple = RippleActions.new(ripple: ripple, param: create_params).create! 

    if ripple.persisted?
       json_response 201,
        success: true,
        message_id: 'record_created',
        message: I18n.t('success.record_created'),
        data: { ripple: ripple }
    else
      unless ripple.errors.empty?
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          errors: ripple.errors
      else
        raise CantSaveError
      end

    end

  end

  private

  def create_params
    params.require(:ripple).permit(:trigger_id, :trigger_type, :triggee_id, 
                                   :user_id, :message, :pushable)
  end

end
