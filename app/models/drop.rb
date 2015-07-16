class Drop < ActiveRecord::Base
  attr_accessor :media_url, :thumbnail_url

  after_destroy :check_remaining_drops

  belongs_to :bucket, counter_cache: true

  belongs_to :user

  has_many :tags, as: :taggable, dependent: :destroy

  has_many :watchers, as: :watchable, dependent: :destroy

  # Should this be dependent destroy?
  has_many :interactions, as: :topic, dependent: :destroy

  has_many :votes, dependent: :destroy

  has_many :redrops, class_name: "Drop", foreign_key: "drop_id", dependent: :destroy

  belongs_to :original_drop, class_name: "Drop", foreign_key: "drop_id"

  validates :media_key, length: { in: 60..120, message: I18n.t('validation.key_length')}

  validates :thumbnail_key, length: { in: 60..120, message: I18n.t('validation.key_length')}, if: 'media_type==1'

  validate :key_uniqueness, on: :create

  validates :media_type, numericality: { message: I18n.t('validation.media_type_missing')}

  def generate_download_uri(thumbnail: nil, media: nil)
    obj = Aws::S3::Object.new(
      bucket_name: ENV['S3_BUCKET'],
      key: thumbnail || media
    )

    if media 
      self.media_url = obj.presigned_url(:get, expires_in: 3600)
    elsif thumbnail 
      self.thumbnail_url = obj.presigned_url(:get, expires_in: 3600)
    end
  end

  def key_uniqueness
    media_key_exists = Drop.where(
      'media_key=? OR media_key=?', self.media_key, self.thumbnail_key)
    thumbnail_key_exists = Drop.where(
      'thumbnail_key=? OR thumbnail_key=?', self.media_key, self.thumbnail_key)

    unless media_key_exists.empty? || drop_id != nil
      errors.add(:media_key, I18n.t('validation.unique_key_exists'))
    end

    unless thumbnail_key_exists.empty? || drop_id != nil
      errors.add(:thumbnail_key, I18n.t('validation.unique_key_exists'))
    end

  end

  private

  def check_remaining_drops
    if !bucket.user_bucket? and bucket.drops_count == 1
      bucket.destroy
    end
  end

end
