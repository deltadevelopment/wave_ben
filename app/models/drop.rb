class Drop < ActiveRecord::Base

  attr_accessor :media_url

  belongs_to :bucket, counter_cache: true

  belongs_to :user

  has_many :tags, as: :taggable, dependent: :destroy

  validates :media_key, length: { in: 60..120, message: I18n.t('validation.key_length')}

  validates :thumbnail_key, length: { in: 60..120, message: I18n.t('validation.key_length')}, if: 'self.media_type==1'

  validate :key_uniqueness

  validates :media_type, numericality: { message: I18n.t('validation.media_type_missing')}

  def generate_download_uri(key)
    obj = Aws::S3::Object.new(
      bucket_name: ENV['S3_BUCKET'],
      key: key
    )

    self.media_url = obj.presigned_url(:get, expires_in: 3600)
  end

  def key_uniqueness
    media_key_exists = Drop.where(
      'media_key=? OR media_key=?', self.media_key, self.thumbnail_key)
    thumbnail_key_exists = Drop.where(
      'thumbnail_key=? OR thumbnail_key=?', self.media_key, self.thumbnail_key)

    unless media_key_exists.empty?
      errors.add(:media_key, I18n.t('validation.unique_key_exists'))
    end

    unless thumbnail_key_exists.empty?
      errors.add(:media_key, I18n.t('validation.unique_key_exists'))
    end

  end

end
