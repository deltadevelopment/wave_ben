class UsersController < ApplicationController

  after_action :verify_authorized, except: :create

  def create
    user = User.new(create_params)
    
    if user.save
      
      # TODO Refactor creation of buckets into a service
      
      user_session = UserSession.new.generate_token(user.id)
      user_session.save

      bucket = Bucket.create({
        user_id: user.id,
        bucket_type: :user
      })

      json_response 201,
        success: true, 
        message_id: 'user_created',
        message: I18n.t('success.user_created'),
        data: { 
          user: remove_unsafe_keys(user),
          session: user_session.slice(:auth_token),
          bucket: bucket
        }

    else
      
      if user.errors
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          data: { error: user.errors }
      end

    end

  end

  def destroy
    user = User.find(params[:id])

    authorize user 

    user.destroy!

    json_response 200,
      success: true,
      message_id: 'user_destroyed',
      message: I18n.t('success.user_destroyed')

  end

  def update
    user = User.find(params[:id])   
  
    authorize user

    if user.update_attributes(update_params)
      json_response 200,
        success: true, 
        message_id: 'user_updated',
        message: I18n.t('success.user_updated'),
        data: { user: remove_unsafe_keys(user) }

    else
      
      if user.errors
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          data: { error: user.errors }
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

  def update_params 
    params.require(:user).permit(
      :password,
      :email,
      :private_profile,
      :phone_number
    )
  end

  def remove_unsafe_keys(user)
    user.slice('id', 'display_name', 'username', 'email', 'phone_number')
  end


end
