class Tag < ActiveRecord::Base
  
  attr_accessor :tag_string
  # TODO Add validation for tag_string

  belongs_to :taggable, polymorphic: true
  belongs_to :taggee, polymorphic: true

  validates :tag_string, format: { with: /\A(#[a-z]\w*)|(@\w+)\z/i, message: I18n.t('validation.tag_string_format') }

  validate :bucket_type_cant_be_user_bucket

  def bucket_type_cant_be_user_bucket
    if self.taggable.is_a?(Bucket) && self.taggable.bucket_type == 'user'
      errors.add(:bucket_type, I18n.t('validation.tag_bucket_type_invalid'))
    end
  end

end
