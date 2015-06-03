class UserSessionActions
  
  def initialize(user: nil, param: nil)
    @user  = user
    @param = param
  end

  def create!
    @user = find_user_by_username_and_password(
      @param[:username], @param[:password])

    if @user
      user_session = generate_session(@user, @param)
      bucket       = Bucket.where(
        bucket_type:  Bucket.bucket_types[:user],
        user_id:      @user.id
      ).take!

      check_device_id_and_arn(user_session)
      
      [user_session, bucket, @user]

    else
      nil
    end

  end 

  private
  
  def generate_session(user, param)
    user_session = UserSession.find_or_create_by(user_id: user.id)

    user_session.update(
      auth_token:   generate_token,
      device_id:    param[:device_id],
      device_type:  param[:device_type]
    )

    user_session
  end

  def check_device_id_and_arn(user_session)
    arn = get_arn(@param[:device_type])

    unless arn == nil or @param[:device_id] == nil
      update_token_params = { 
        arn:        arn,
        device_id:  @param[:device_id],
        user_id:    user_session.user_id
      }

      add_device_id_sns(user_session, update_token_params)

    end

  end

  def add_device_id_sns(user_session, update_token_params)
    device_id_in_use = UserSession.device_id_in_use(user_session)

    if !device_id_in_use.nil?
      AddDeviceTokenJob.perform_later(update_token_params, device_id_in_use.user.sns_endpoint_arn)
      reset_session_and_user_with_device_id(device_id_in_use)
    else
      AddDeviceTokenJob.perform_later(update_token_params)
    end
  end

  def reset_session_and_user_with_device_id(user_session)
    user_session.user.update_attributes(sns_endpoint_arn: nil)
    user_session.destroy
  end

  def generate_token
    begin
      auth_token = SecureRandom.hex
    end while UserSession.exists?(auth_token: auth_token)

    auth_token 
  end

  def get_arn(device_type)
    case device_type
    when 'ios'
      arn = ENV['AWS_SNS_IOS_ARN']
    when 'android'
      arn = ENV['AWS_SNS_AND_ARN']
    else
      arn = nil
    end
    # This return might be refactored out
    arn
  end

  def find_user_by_username_and_password(username, password)
    user = User.find_by_username(username)

    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end

  end

end
