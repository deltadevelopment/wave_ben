class Bucket < ActiveRecord::Base

  enum bucket_type: [:shared, :user]
  enum visibility: [:everyone, :tagged]

  belongs_to :user

  has_many :tags, as: :taggable, dependent: :destroy

  has_many :drops, dependent: :destroy

  validates :title, length: { in: 1..25, message: I18n.t('validation.title_length')}, if: :shared?

  validates :description, length: { in: 0..250, message: I18n.t('validation.description_length')}, if: :shared_and_entered_description?

  private

  def shared_and_entered_description?
    self.shared? && !description.nil?
  end
  
end
