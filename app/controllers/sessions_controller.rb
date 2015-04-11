class SessionsController < ApplicationController
  before_action :check_session, only: :destroy

  def create
    user = authenticate(params[:username], params[:password])
    
    if user
      session = Session.find_or_create_by(user_id: user.id)
      session.generate_token(user.id)
      
      session.save!
       
      json_response 200,
        success: true, 
        message_id: 'session_created',
        message: I18n.t('success.session_created'),
        data: {
          session: {
            auth_token: session.auth_token,
            user_id: session.user_id
          }
        }
    else
      json_response 401,
        success: false, 
        message_id: 'bad_credentials',
        message: I18n.t('error.bad_credentials')
    end

  end  

  def destroy

    @session.destroy!
    
    json_response 200,
      success: true,
      message_id: 'session_destroyed',
      message: I18n.t('success.session_destroyed')

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
