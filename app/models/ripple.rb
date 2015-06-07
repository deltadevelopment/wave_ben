class Ripple < ActiveRecord::Base

  after_create :notify_user

  belongs_to :user

  belongs_to :triggee, class_name: 'User'

  belongs_to :trigger, polymorphic: true 

  validates :message, 
    presence: { message: I18n.t('validation.notification_message') }

  def self.get_new_ripples(user)
    ripples = self.where(user: user, seen_at: nil)
    rr = ripples.to_a
    ripples.update_all(seen_at: DateTime.now)
 
    rr
  end

  private

  def notify_user
    if pushable
      user.notify(message)
    end
  end

end
