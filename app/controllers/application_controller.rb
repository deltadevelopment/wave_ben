class ApplicationController < ActionController::API
  
  include Pundit

  class NotAuthenticatedError < StandardError; end 
  class CantSaveError < StandardError; end  # Needs to be logged

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from NotAuthenticatedError, with: :not_authenticated
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def json_response(status, res)

    json = {
      success: res[:success],
      message: res[:message],
      message_id: res[:message_id]
    }

    data = {
      data: res[:data] 
    }

    errors = {
      errors: res[:errors]
    }

    json.merge!(data) unless res[:data].nil?
    json.merge!(errors) unless res[:errors].nil?

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
  
  def record_not_found 
    json_response 404,
      success: false,
      message_id: "record_not_found",
      message: I18n.t('error.not_found')
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
    raise NotAuthenticatedError unless @user_session
    @user_session
  end
 
  def current_user
    check_session unless @user_session
    @user = User.find(@user_session.user_id)
  end

  def get_auth_token
    if !params[:auth_token].blank?
      params[:auth_token]
    elsif !request.headers['X-AUTH-TOKEN'].blank?
      request.headers['X-AUTH-TOKEN']
    else
      nil 
    end
  end
end
