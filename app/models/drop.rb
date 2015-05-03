class Drop < ActiveRecord::Base

  belongs_to :bucket
  belongs_to :user

  has_many :tags, as: :taggable

  acts_as_nested_set

  validates :media_key, length: { in: 60..120, message: I18n.t('validation.media_key_length')},
                        uniqueness: { message: I18n.t('validation.media_key_unique') }

end
