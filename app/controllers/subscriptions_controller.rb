class SubscriptionsController < ApplicationController

  def create
    subscription = Subscription.new(create_params)

    authorize subscription

    if subscription.save
        json_response 201,
          success: true,
          message_id: 'record_created',
          message: I18n.t('success.record_create'),
          data: {
            subscription: subscription
          }
    else

      if subscription.errors
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          data: {
            error: subscription.errors
          }
      else
        raise CantSaveError
      end

    end

  end

  def destroy
    subscription = Subscription.where(
      user_id: params[:user_id],
      subscribee_id: params[:subscribee_id]
    ).take!

    authorize subscription

    subscription.destroy!

    json_response 204,
      success: true,
      message_id: 'record_created',
      message: I18n.t('success.record_create'),
      data: {
        subscription: subscription
      }

  end

  private

  def create_params
    params.permit(:user_id, :subscribee_id)
  end

end
