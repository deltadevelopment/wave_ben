class Vote < ActiveRecord::Base

  belongs_to :user
  belongs_to :drop
  belongs_to :bucket

  has_many :ripples, as: :trigger, dependent: :destroy

  validates :temperature, numericality: { 
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 100,
      message: I18n.t('validation.temperature_must_be_between_0_100')
    }

end
