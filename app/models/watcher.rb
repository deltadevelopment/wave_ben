class Watcher < ActiveRecord::Base

  belongs_to :user

  belongs_to :watchable, polymorphic: true 

end
