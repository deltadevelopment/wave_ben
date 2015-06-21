class User < ActiveRecord::Base

  attr_accessor :password, :bucket, :profile_picture_url

  enum device_type: [:ios, :android]

  has_one :user_session, dependent: :destroy

  has_many :buckets, dependent: :destroy
  has_many :drops, dependent: :destroy

  has_many :tags, as: :taggee, dependent: :destroy

  has_many :subscribees,
    foreign_key: 'user_id', class_name: 'Subscription', dependent: :destroy

  has_many :subscribers, 
    foreign_key: 'subscribee_id', class_name: 'Subscription', dependent: :destroy

  has_many :votes, dependent: :destroy

  has_many :ripples, dependent: :destroy

  delegate :user_bucket, to: :buckets

  before_save :encrypt_password

  validates :username, length: { in: 1..20, message: I18n.t('validation.username_length') }
  validates :username, uniqueness: { message: I18n.t('validation.username_exists') }
  validates_format_of :username, :with => /\A\w+\z/i, message: I18n.t('validation.username_alphanumeric')

  validates :display_name, length: { in: 1..25, message: I18n.t('validation.display_name_length') }, if: :display_name_entered
  validates_format_of :display_name, :with => /\A[a-z0-9]+ *[a-z0-9]*\z/i, :message => I18n.t('validation.display_name_format'),if: :display_name_entered
  
  # This is for other actions than on: :create 
  # TODO: This might be redundant
  validates :password, length: { in: 6..20}, if: :password_entered, on: :update
  validates :password, length: { in: 6..20, message: I18n.t('validation.password_length') }, on: :create
  
  # TODO: Get better regex for email validation
  validates_format_of :email, 
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    message: I18n.t('validation.email_format')
  validates :email, uniqueness: { message: I18n.t('validation.email_exists') }

  validates :phone_number, numericality: {message: I18n.t('validation.phone_number_numerical') }, 
    uniqueness: { message: I18n.t('validation.phone_number_exists') },
    if: :phone_number_entered

  def bucket
    Bucket.where("user_id=? AND bucket_type=0", self.id)
  end

  def is_owner?(resource)
    self.id == resource.user_id
  end

  def generate_download_uri
    obj = Aws::S3::Object.new(
      bucket_name: ENV['S3_PROFILE_BUCKET'],
      key: self.profile_picture_key
    )

    self.profile_picture_url = obj.presigned_url(:get, expires_in: 3600) 
  end

  def notify(message)
    unless self.sns_endpoint_arn == nil
      pen = Aws::SNS::Resource.new.platform_endpoint(self.sns_endpoint_arn)
      pen.publish(message: message, message_structure: 'json')
      return true
    end
    false
  end

  def get_unseen_ripple_count
    ripples = Ripple.where(user_id: self.id, seen_at: nil).select("COUNT(ripples.user_id) AS total, ripples.user_id").group("ripples.id, ripples.user_id")
    ripples.first ? ripples.first.total : 0
  end

  protected 

  # Returns true if a phone number was entered
  def phone_number_entered
    !phone_number.nil?
  end
  
  # Returns true if an e-mail adress was entered 
  def email_entered
    !email.nil?  
  end

  def password_entered
    !password.nil?
  end

  def display_name_entered
    !display_name.nil?
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end 

end
