class UserActions

  def initialize(user: nil, params: nil)
    @user = user
    @params = params
  end

  def register

    if @user.save
      user_session = UserSessionActions.new(
        user: @user, 
        params: @params
      ).create!

      bucket = Bucket.create({
        user_id: @user.id,
        bucket_type: :user
      })
    end

    [@user, user_session, bucket]
  end

end
