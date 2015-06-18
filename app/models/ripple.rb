class Ripple < ActiveRecord::Base

  after_create :notify_user

  belongs_to :user

  belongs_to :triggee, class_name: 'User'

  belongs_to :trigger, polymorphic: true 

  validates :message, 
    presence: { message: I18n.t('validation.notification_message') }

  # TODO: Possible optimization handle this in the db
  def self.get_new_ripples(user)
    # ripples = self.where(user: user).order("created_at DESC, seen_at DESC NULLS FIRST")
    ripples = self.where(user: user).order("created_at DESC, seen_at DESC") 

    ripples.take!

    rr = ripples.to_a
    ripples.update_all(seen_at: DateTime.now)
 
    rr
  end

  private

  def notify_user
    if pushable
      if user.ios?      
        inner = { "aps": { "alert": "Test" } }.to_json
        padded_message = '{ "APNS_SANDBOX": \"' + inner + '\" }'
      else
        padded_message = message
      end
      user.notify(padded_message)
    end
  end

end
