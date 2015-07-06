class Subscription < ActiveRecord::Base

  belongs_to :user, counter_cache: :subscriptions_count
  belongs_to :subscribee, class_name: 'User', counter_cache: :subscribers_count

  has_many :interactions, as: :topic, dependent: :destroy

  validate :subscribee_cant_be_user 

  private

  def subscribee_cant_be_user
    if subscribee == user
      errors.add(:user, I18n.t('validation.subscribee_cant_be_user'))
    end
  end

end
