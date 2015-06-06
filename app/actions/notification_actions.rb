class NotificationActions

  def initialize(notification: nil, param: nil)
    @notification = notification
    @param = param 
  end

  def create!
      
    @notification.save!

  end

end
