class Interaction < ActiveRecord::Base

  has_many :ripples, dependent: :destroy

  belongs_to :user
  
  belongs_to :topic, polymorphic: true

end
