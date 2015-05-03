class Hashtag < ActiveRecord::Base

  has_many :tags, as: :taggee

end
