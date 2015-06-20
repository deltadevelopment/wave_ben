class Ripple < ActiveRecord::Base

  after_create :notify_user

  belongs_to :interaction

  belongs_to :user

  def notify_user


  end

  private

  def notify_user
    message = generate_message

    if user.ios?      
      inner = {
        "aps": {
          "alert": message
        }
      }
      padded_message = { APNS_SANDBOX: inner }.to_json
    else
      padded_message = message
    end

    user.notify(padded_message)
  end

  def generate_message
    "The message"
  end

end
