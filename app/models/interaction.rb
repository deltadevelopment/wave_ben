class Interaction < ActiveRecord::Base

  has_many :ripples

  belongs_to :user
  
  belongs_to :topic, polymorphic: true

end
