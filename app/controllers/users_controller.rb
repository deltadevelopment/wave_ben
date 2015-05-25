class UsersController < ApplicationController
  after_action :verify_authorized, except: :create

  def show
    user = User.find(params[:user_id])
    
    authorize user

    json_response 200,
      success: true,
      message: I18n.t('success.ok'),
      message_id: 'ok',
      data: UserSerializer.new(user)
  end

  def create
    user, user_session, bucket = 
      UserActions.new(
        user: User.new(create_params),
        param: params
      ).register

    if user.persisted? 

      json_response 201,
        success: true, 
        message_id: 'user_created',
        message: I18n.t('success.user_created'),
        data: { 
          user: remove_unsafe_keys(user),
          session: user_session[0].slice(:auth_token),
          bucket: bucket.slice(:id)
        }

    else
      
      unless user.errors.empty?
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          data: { error: user.errors }
      else
        raise CantSaveError
      end

    end

  end

  def update
    user = User.find(params[:user_id])   
  
    authorize user

    if user.update_attributes(update_params)
      json_response 200,
        success: true, 
        message_id: 'user_updated',
        message: I18n.t('success.user_updated'),
        data: { user: remove_unsafe_keys(user) }

    else
      
      unless user.errors.empty?
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          data: { error: user.errors }
      else
        raise CantSaveError
      end

    end

  end

  def destroy
    user = User.find(params[:user_id])

    authorize user 

    user.destroy!

    json_response 204,
      success: true,
      message_id: 'user_destroyed',
      message: I18n.t('success.user_destroyed'),
      data: {
        user: remove_unsafe_keys(user)
      }

  end

  def generate_upload_url
    authorize User.new

    url, key = aws_generate_upload_url(bucket: 'S3_PROFILE_BUCKET')

    json_response 200,
      success: true,
      message_id: 'upload_url_generated',
      message: I18n.t('success.upload_url_generated'),
      data: {
        upload_url: {
          url: url.to_s,
          media_key: key
        }
      }
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
      :phone_number,
      :profile_picture_key
    )
  end

  def remove_unsafe_keys(user)
    user.slice('id', 'display_name', 'username', 'email', 'phone_number')
  end

end
