class UserSessionsController < ApplicationController
  before_action :check_session, only: :destroy

  def create
    user = authenticate(params[:username], params[:password])

    if user
      @user_session = update_token(user, params)
      arn = get_arn(params[:device_type])

      unless arn == nil or params[:device_id] == nil
        update_token_params = { arn: arn, device_id: @user_session.device_id, user_id: user.id }

        add_device_id_sns(update_token_params)

      end

      @user_session.save!

      json_response 200,
        success: true,
        message_id: 'user_session_created',
        message: I18n.t('success.user_session_created'),
        data: {
          user_session: {
            auth_token: @user_session.auth_token,
            user_id: @user_session.user_id
          }
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

  def update_token(user, param)
      user_session = UserSession.find_or_create_by(user_id: user.id)
      user_session.generate_token(user.id)
      user_session.device_id = param[:device_id]
      user_session
  end

  def add_device_id_sns(update_token_params)
    device_id_in_use = UserSession.device_id_in_use(@user_session)
    unless device_id_in_use.nil?
      Resque.enqueue(AddDeviceToken, update_token_params, device_id_in_use.user.sns_endpoint_arn)
      device_id_in_use.user.update_attributes(sns_endpoint_arn: nil)
      device_id_in_use.destroy
    else
      Resque.enqueue(AddDeviceToken, update_token_params)
    end
  end

  def get_arn(device_type)
    case device_type
    when 'ios'
      arn = ENV['AWS_SNS_IOS_ARN']
     else
      arn = nil
    end

    arn
  end

  def destroy
    @user_session.destroy!

    json_response 200,
      success: true,
      message_id: 'user_session_destroyed',
      message: I18n.t('success.user_session_destroyed')

  end

  private

  def authenticate(username, password)


    user = User.find_by_username(username)

    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end

  end

end
