class Bucket < ActiveRecord::Base

  enum bucket_type: [:shared, :user]
  enum visibility: [:everyone, :followers, :tagged]

  belongs_to :user

  has_many :drops, dependent: :destroy

  validates :title, length: { in: 1..25, message: I18n.t('validation.title_length')}, if: :shared?

  validates :description, length: { in: 0..250, message: I18n.t('validation.description_length')}, if: :shared_and_entered?

  private

  def shared_and_entered?
    self.shared? && !description.nil?
  end
  
end
