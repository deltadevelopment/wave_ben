class FollowingsController < ApplicationController

  def create_or_request
    user = User.find(params[:user_id]) 
    followee = User.find(params[:followee_id]) 

    following = FollowingActions.new(
      following: Following.new(create_params)
    ).create_or_request!


  end

  private

  def create_params
    params.permit(:user_id, :followee_id)
  end 

end
