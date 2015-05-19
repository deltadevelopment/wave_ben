class Drop < ActiveRecord::Base

  attr_accessor :media_url

  belongs_to :bucket, counter_cache: true

  belongs_to :user

  has_many :tags, as: :taggable, dependent: :destroy

  validates :media_key, length: { in: 60..120, message: I18n.t('validation.media_key_length')},
                        uniqueness: { message: I18n.t('validation.media_key_unique') }

  validates :media_type, numericality: { message: I18n.t('validation.media_type_missing')}


   def generate_download_uri
    obj = Aws::S3::Object.new(
      bucket_name: ENV['S3_BUCKET'],
      key: self.media_key
    )

    self.media_url = obj.presigned_url(:get, expires_in: 3600)
  end

end
