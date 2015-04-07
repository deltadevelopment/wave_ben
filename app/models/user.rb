class User < ActiveRecord::Base

  attr_accessor :password, :auth_token

  has_one :session

  before_save :encrypt_password

  validates :username, length: { in: 1..20, message: "must be between 1 and 15 characters" }
  validates :username, uniqueness: true
  validates_format_of :username, :with => /\A\w+\z/i, :message => "can only contain letters and numbers"

  validates :display_name, length: { in: 1..25, message: "must be between 4 and 25 characters" }, if: :display_name_entered
  validates_format_of :display_name, :with => /\A[a-z0-9]+ *[a-z0-9]*\z/i, :message => "can only contain letters, spaces, and numbers", if: :display_name_entered
  
  # This is for other actions than on: :create 
  # TODO: This might be redundant
  validates :password, length: { in: 6..20, message: "must be between 6 and 20 characters" }, if: :password_entered
  
  # TODO: Get better regex for email validation
  validates_format_of :email, 
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, uniqueness: true

  validates :phone_number, numericality: {message: "can only contain digits"}, uniqueness: true,
            if: :phone_number_entered

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
