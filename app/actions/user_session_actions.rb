class UserSessionActions
  
  def initialize(user: nil, params: nil)
    @user   = user
    @params = params
  end

  def create!
    user = find_user_by_username_and_password(
      @params[:user][:username], @params[:user][:password])

    if user
      user_session = generate_session(user, @params)

      arn = get_arn(@params[:device_type])

      unless arn == nil or @params[:device_id] == nil

        update_token_params = { 
          arn: arn, 
          device_id: @params[:device_id],
          user_id: user.id 
        }

        add_device_id_sns(user_session, update_token_params)

      end
      
      user_session

    else
      nil
    end

  end 

  private
  
  def generate_session(user, params)
    user_session = UserSession.find_or_create_by(user_id: user.id)

    user_session.update(
      auth_token: generate_token,
      device_id: params[:device_id],
      device_type: params[:device_type]
    )

    user_session
  end

  def add_device_id_sns(user_session, update_token_params)
    device_id_in_use = UserSession.device_id_in_use(user_session)
    unless device_id_in_use.nil?
      Resque.enqueue(AddDeviceToken, update_token_params, device_id_in_use.user.sns_endpoint_arn)
      device_id_in_use.user.update_attributes(sns_endpoint_arn: nil)
      device_id_in_use.destroy
    else
      Resque.enqueue(AddDeviceToken, update_token_params)
    end
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
     else
      arn = nil
    end

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
