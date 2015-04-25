class UserSession < ActiveRecord::Base

  belongs_to :user

  enum device_type: [:ios, :android]

  def self.device_id_in_use(user_session)
    device_id_other_user = UserSession.where(
      "device_id=? AND user_id != ?", user_session.device_id, user_session.user_id).take
  end

end
