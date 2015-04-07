class UsersController < ApplicationController

  def create
    user = User.new(create_params)
    
    if user.save

      json_response 200,
        success: true, 
        message_id: 'user_created',
        message: I18n.t('success.user_created'),
        data: { user: remove_unsafe_keys(user) }

    else
      
      if user.errors
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          data: { error: user.errors }
      end

      # TODO: Handle missing user[]  

    end

  end

  # Used in SessionsController#create
  def self.authenticate(username, password)
   
    user = User.find_by_username(username)

    if user && user.password_hash == 
               BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end

  end

  private 

  def create_params 
    params.require(:user).permit(
      :username,
      :password,
      :email,
      :private_profile,
      :phone_number
    )
  end

  def remove_unsafe_keys(user)
    user.slice('id', 'display_name', 'username', 'email', 'phone_number', 'auth_token')
  end


end
