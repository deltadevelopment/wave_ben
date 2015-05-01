class Tag < ActiveRecord::Base

  belongs_to :drop
  belongs_to :bucket

  has_many :hashtags

end
