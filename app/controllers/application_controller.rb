class ApplicationController < ActionController::API

  def json_response(status, res)

    json = {
      success: res[:success],
      message: res[:message],
      message_id: res[:message_id]
    }

    json.merge!(res[:data]) unless res[:data].nil?
    json.merge!(res[:error]) unless res[:error].nil?

    render json: json, status: status 
     
  end

end
