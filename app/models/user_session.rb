class UserSession < ActiveRecord::Base

  belongs_to :user

  enum device_type: [:ios, :android]

  def generate_token(user_id)
    begin
      auth_token = SecureRandom.hex
    end while self.class.exists?(auth_token: auth_token)
    
    self.auth_token = auth_token
    self.user_id = user_id 
    self
  end


end
