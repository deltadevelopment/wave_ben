class WatcherPolicy < ApplicationPolicy

  def unwatch?
    user_is_owner?
  end

end
