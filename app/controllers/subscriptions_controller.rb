class SubscriptionsController < ApplicationController
  after_action :verify_authorized

  def show
    subscription = Subscription.where(user_id: params[:user_id], subscribee_id: params[:subscribee_id]).take!

    authorize subscription
    
    json_response 200,
      success: true,
      message_id: 'ok',
      message: I18n.t('success.ok'),
      data: {
        subscription: subscription
      }
  end

  def create
    user = User.find(params[:user_id])
    authorize Subscription.new(user: user)

    subscribee = User.find(params[:subscribee_id])
    subscription = Subscription.find_or_create_by(create_params)


    if subscription.save
        json_response 201,
          success: true,
          message_id: 'record_created',
          message: I18n.t('success.record_created'),
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
      message_id: 'record_destroyed',
      message: I18n.t('success.record_destroyed'),
      data: {
        subscription: subscription
      }

  end

  private

  def create_params
    params.permit(:user_id, :subscribee_id)
  end

end
