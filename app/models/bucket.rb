class Bucket < ActiveRecord::Base

  enum bucket_type: [:shared, :user]
  enum visibility: [:everyone, :taggees]

  scope :user_bucket, -> { where(bucket_type: 1) }

  belongs_to :user

  has_many :tags, as: :taggable, dependent: :destroy

  has_many :drops, dependent: :destroy

  has_many :watchers, as: :watchable, dependent: :destroy

  has_many :ripples, as: :trigger, dependent: :destroy

  has_many :votes

  validates :title, length: { in: 1..25, message: I18n.t('validation.title_length')}, if: :shared?

  # Validations to not allow user buckets to update

  validate :user_bucket_cant_have_shared_bucket_attributes

  def user_bucket?
    bucket_type == 'user'
  end

  private

  def user_bucket_cant_have_shared_bucket_attributes
    if bucket_type == 'user' 
      unless title.nil?
        errors.add(:bucket_type, I18n.t('validation.user_bucket_title_set'))
      end
    end
  end
  
end
