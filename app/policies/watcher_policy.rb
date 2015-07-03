class WatcherPolicy < ApplicationPolicy

  def unwatch?
    user_is_owner?
  end

  def list_watchers?
    # TODO: FIX THIS!!!!
    true    
  end

end
