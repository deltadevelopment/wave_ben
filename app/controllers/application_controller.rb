class ApplicationController < ActionController::API
  
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def json_response(status, res)

    json = {
      success: res[:success],
      message: res[:message],
      message_id: res[:message_id]
    }

    data = {
      data: res[:data] 
    }

    json.merge!(data) unless res[:data].nil?

    render json: json, status: status 
     
  end

  # General error messages

  def not_authorized
    json_response 401,
      success: false,
      message_id: "not_authorized",
      message: I18n.t('error.not_authorized')
  end
  
  def not_authenticated
    json_response 401,
      success: false,
      message_id: "not_authenticated",
      message: I18n.t('error.not_authenticated')
  end

  def parameter_missing(exception)
    json_response 400,
      success: false,
      message_id: "parameter_missing",
      message: exception.to_s
  end

  # Authorization

  def check_session
    @user_session = UserSession.find_by_auth_token(get_auth_token)
    return not_authenticated unless @user_session
    @user_session
  end

  # Used for serializer
  # Needs check_session to be called in beforehand
  def current_user
    check_session unless @user_session
    @user = User.find(@user_session.user_id)
  end

  def get_auth_token
    unless params[:auth_token].blank?
      return params[:auth_token]
    end

    unless request.headers['X-AUTH-TOKEN'].blank?
      return request.headers['X-AUTH-TOKEN']
    end

    false 
  end

end
