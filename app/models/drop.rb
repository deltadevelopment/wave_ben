class Drop < ActiveRecord::Base

  belongs_to :bucket
  belongs_to :user

  has_many :tags, as: :taggable, dependent: :destroy

  acts_as_nested_set

  validates :media_key, length: { in: 60..120, message: I18n.t('validation.media_key_length')},
                        uniqueness: { message: I18n.t('validation.media_key_unique') }

  def set_parent_id
    parent_id = Drop.where(
      "bucket_id=? AND user_id=?", self.bucket.id, self.bucket.user_id
    ).order(created_at: :desc).pluck(:id).first
    self.parent_id = parent_id unless self.user.is_owner?(self.bucket)
  end

end
