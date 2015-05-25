class UserActions

  def initialize(user: nil, param: nil)
    @user = user
    @param = param
  end

  def register

    if @user.save
      bucket = Bucket.create({
        user_id: @user.id,
        bucket_type: :user
      })

      user_session = UserSessionActions.new(
        user: @user, 
        param: @param[:user]
      ).create!

    end

    [@user, user_session, bucket]
  end

end
