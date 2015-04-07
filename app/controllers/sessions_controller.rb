class SessionsController < ApplicationController

  def create
    user = UsersController.authenticate(params[:username], params[:password])
    
    if user
      session = Session.find_by_user_id(user.id) || Session.new(user_id: user.id)
      session.generate_token(user.id)
      
      session.save!
       
      json_response 200,
        success: true, 
        message_id: 'session_created',
        message: I18n.t('success.session_created')
    else
      json_response 401,
        success: true, 
        message_id: 'bad_credentials',
        message: I18n.t('error.bad_credentials')
    end

  end  

end
