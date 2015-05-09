class SubscriptionsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    subscribee = User.find(params[:subscribee_id])
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
      raise CantSaveError
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
