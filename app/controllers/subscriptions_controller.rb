class SubscriptionsController < ApplicationController
  after_action :verify_authorized

  def show
    subscription = Subscription.where(user_id: params[:user_id], subscribee_id: params[:subscribee_id]).take!

    authorize subscription
    
    json_response 200,
      success: true,
      message_id: 'ok',
      message: I18n.t('success.ok'),
      data: SubscriptionSerializer.new(subscription)
  end

  def list
    subscriptions = Subscription.where(user_id: params[:user_id])

    authorize subscriptions.take!
    
    json_response 200,
      success: true,
      message_id: 'ok',
      message: I18n.t('success.ok'),
      data: ActiveModel::ArraySerializer.new(
        subscriptions,
        each_serializer: SubscriptionSerializer,
        root: "subscriptions"
      )
  end

  def create
    user = User.find(params[:user_id])
    subscribee = User.find(params[:subscribee_id])

    authorize Subscription.new(user: user)

    subscription = SubscriptionActions.new(
      subscription: Subscription.new(create_params)
    ).create!

    if subscription.persisted?
        json_response 201,
          success: true,
          message_id: 'record_created',
          message: I18n.t('success.record_created'),
          data: {
            subscription: subscription
          }
    else
      unless subscription.errors.empty?
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          data: { error: subscription.errors }
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
