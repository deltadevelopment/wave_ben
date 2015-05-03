class Tag < ActiveRecord::Base

  belongs_to :taggable, polymorphic: true
  belongs_to :taggee, polymorphic: true

end
