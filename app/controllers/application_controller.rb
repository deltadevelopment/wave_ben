class ApplicationController < ActionController::API

  def json_response(res)

    json = {
      success: res[:success],
      message: res[:message],
      display_message: res[:display_message]
    }

    json.merge!(res[:data]) unless res[:data].nil?
    json.merge!(res[:error]) unless res[:error].nil?

    render json: json, status: res[:status]
     
  end

  def internal_server_error
    json_response(
      status: 500,
      success: false,
      message: "Internal server error",
      display_message: "Internal server error" 
    )
  end
end
