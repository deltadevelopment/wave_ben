class Tag < ActiveRecord::Base

  scope :user_tag, -> { where(taggee_type: 'User') } 
  scope :bucket_tag, -> { where(taggable_type: 'Bucket') }
  scope :tags_for_user, -> (user) { where(taggee: user) }

  attr_accessor :tag_string

  has_many :interactions, as: :topic, dependent: :destroy

  belongs_to :taggable, polymorphic: true
  belongs_to :taggee, polymorphic: true

  validates :tag_string, format: { with: /\A(#[a-z]\w*)|(@\w+)\z/i, message: I18n.t('validation.tag_string_format') }

  validate :bucket_type_cant_be_user_bucket

  validate :taggee_cant_be_owner

  private

  def taggee_cant_be_owner
    if self.taggable.is_a?(Bucket) && self.taggee == self.taggable.user
      errors.add(:user, I18n.t('validation.taggee_cant_be_owner'))
    end
  end

  def bucket_type_cant_be_user_bucket
    if self.taggable.is_a?(Bucket) && self.taggable.bucket_type == 'user'
      errors.add(:bucket_type, I18n.t('validation.tag_bucket_type_invalid'))
    end
  end

end
