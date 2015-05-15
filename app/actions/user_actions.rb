class UserActions

  def initialize(user: nil, params: nil)
    @user = user
    @params = params
  end

  def register

    if @user.save
      bucket = Bucket.create({
        user_id: @user.id,
        bucket_type: :user
      })

      user_session = UserSessionActions.new(
        user: @user, 
        params: @params[:user]
      ).create!

    end

    [@user, user_session, bucket]
  end

end
