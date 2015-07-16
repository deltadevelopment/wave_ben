class Interaction < ActiveRecord::Base

  attr_accessor :users_watching

  has_many :ripples, dependent: :destroy

  belongs_to :user
  
  belongs_to :topic, polymorphic: true

end
