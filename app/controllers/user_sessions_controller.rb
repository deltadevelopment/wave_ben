class UserSessionsController < ApplicationController
  # TODO: `session` is a reserved word in Rails, and we therefor need to change
  # this name
  before_action :check_session, only: :destroy

  def create
    user = authenticate(params[:username], params[:password])

    if user
      user_session = UserSession.find_or_create_by(user_id: user.id)
      user_session.generate_token(user.id)
      user_session.device_id = params[:device_id]
      
      # TODO: Refactor this to smaller methods

      if params[:device_type] == 'ios'
        arn = ENV['AWS_SNS_IOS_ARN']
      end

      unless arn == nil or user_session.device_id == nil
                
        update_token_params = { arn: arn, device_id: user_session.device_id, user_id: user.id }

        device_id_other_user = UserSession.where(
          "device_id=? AND user_id != ?", user_session.device_id, user_session.user_id).take
        
        unless device_id_other_user.nil?
          Resque.enqueue(AddDeviceToken, update_token_params, device_id_other_user.user.sns_endpoint_arn)
          device_id_other_user.user.update_attributes(sns_endpoint_arn: nil)
          device_id_other_user.destroy 
        else
          Resque.enqueue(AddDeviceToken, update_token_params)
        end

      end

      user_session.save! 
       
      json_response 200,
        success: true, 
        message_id: 'user_session_created',
        message: I18n.t('success.user_session_created'),
        data: {
          user_session: {
            auth_token: user_session.auth_token,
            user_id: user_session.user_id
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

    if user && user.password_hash == 
               BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end

  end

end
