class Bucket < ActiveRecord::Base

  enum bucket_type: [:shared, :user]
  enum visibility: [:everyone, :taggees]

  belongs_to :user

  has_many :tags, as: :taggable, dependent: :destroy

  has_many :drops, dependent: :destroy

  validates :title, length: { in: 1..25, message: I18n.t('validation.title_length')}, if: :shared?

  validates :description, length: { in: 0..250, message: I18n.t('validation.description_length')}, if: :shared_and_entered_description?

  # Validations to not allow user buckets to update

  validate :user_bucket_cant_have_shared_bucket_attributes

  private

  def user_bucket?
    bucket_type == 'user'
  end

  def user_bucket_cant_have_shared_bucket_attributes
    if bucket_type == 'user' 
      unless title.nil?
        errors.add(:bucket_type, I18n.t('validation.user_bucket_title_set'))
      end
      unless when_datetime.nil?
        errors.add(:bucket_type, I18n.t('validation.user_bucket_when_datetime_set'))
      end
      unless description.nil?
        errors.add(:bucket_type, I18n.t('validation.user_bucket_description_set'))
      end
    end
  end

  def shared_and_entered_description?
    self.shared? && !description.nil?
  end
  
end
