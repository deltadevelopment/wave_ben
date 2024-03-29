class Vote < ActiveRecord::Base

  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  belongs_to :user
  belongs_to :drop
  belongs_to :bucket

  has_many :interactions, as: :topic, dependent: :destroy

  validates :vote, numericality: { 
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 1,
      message: I18n.t('validation.vote_must_be_between_0_1')
    }

  def to_s
    if vote == 0
      "Funny"
    else
      "Cool"
    end
  end

  private

  def increment_counter_cache
    if vote == 1
      drop.increment(:vote_one_count).save
    else
      drop.increment(:vote_zero_count).save
    end
  end

  def decrement_counter_cache
    if vote == 1
      drop.decrement(:vote_one_count).save
    else
      drop.decrement(:vote_zero_count).save
    end
  end

end
