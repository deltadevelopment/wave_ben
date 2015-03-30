class UsersController < ApplicationController

  def create
    user = User.new(create_params)
    
    if user.save

      json_response(
        status: 200,
        success: true, 
        message: "Resource created",
        display_message: "Add display_message", # TODO
        data: { user: remove_unsafe_keys(user) }
      )

    else
      
      if user.errors
        json_response(
          status: 400,
          success: false,
          message: "Validation error",
          display_message: "Add display_message", # TODO
          data: { error: user.errors }
        )
      else
        internal_server_error 
      end

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
