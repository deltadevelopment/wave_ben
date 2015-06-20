class Ripple < ActiveRecord::Base

  after_create :notify_user

  belongs_to :interaction

  belongs_to :user

  private

  # TODO: Possible optimization handle this in the db
  def self.get_new_ripples(user)
    # ripples = self.where(user: user).order("created_at DESC, seen_at DESC NULLS FIRST")
    ripples = self.where(user: user).order("created_at DESC, seen_at DESC") 

    ripples.take!

    rr = ripples.to_a
    ripples.update_all(seen_at: DateTime.now)
 
    rr
  end

  def notify_user
    message = generate_message

    if user.ios?      
      inner = {
        "aps": {
          "alert": message
        }
      }.to_json
      padded_message = { APNS_SANDBOX: inner }.to_json
    else
      inner = {
        "data": {
          "message": message
        }
      }.to_json
      padded_message = { GCM: inner }.to_json
    end

    user.notify(padded_message)
  end

  def generate_message
    I18n.t "notification.#{interaction.action}",
      username: interaction.user.username,
      bucket_title: interaction.topic.class.method_defined?(:title) ? interaction.topic.title : nil,
      temperature: interaction.topic.class.method_defined?(:temperature) ? interaction.topic.temperature : nil
  end

end
