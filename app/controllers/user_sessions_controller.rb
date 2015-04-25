class UserSessionsController < ApplicationController
  before_action :check_session, only: :destroy

  def create
    user_session = UserSessionActions.new(params: params).create!

    if user_session
      json_response 200,
        success: true,
        message_id: 'user_session_created',
        message: I18n.t('success.user_session_created'),
        data: {
          user_session: user_session.slice(:auth_token, :user_id)
        }
    else
      json_response 401,
        success: false,
        message_id: 'bad_credentials',
        message: I18n.t('error.bad_credentials'),
        error: {
          "password": ["is incorrect"]
        }
    end

  end

  def destroy
    current_user.user_session.destroy!

    json_response 200,
      success: true,
      message_id: 'user_session_destroyed',
      message: I18n.t('success.user_session_destroyed')

  end

  private

  def login_params
    params.require(:user).permit(:username, :password)
  end

end
