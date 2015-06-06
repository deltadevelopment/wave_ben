class Notification < ActiveRecord::Base

  after_create :notify_user

  belongs_to :user

  belongs_to :triggee, class_name: 'User'

  belongs_to :trigger, polymorphic: true 

  validates :message, 
    presence: { message: I18n.t('validation.notification_message') }

  private

  def notify_user
    if pushable
      user.notify(message)
    end
  end

end
