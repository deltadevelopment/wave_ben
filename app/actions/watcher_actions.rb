class WatcherActions

  def initialize(watcher: nil, param: nil)
    @watcher = watcher
    @param   = param
  end

  def create!
    watcher = Watcher.find_or_initialize_by(
      user_id: @watcher.user_id,
      watchable: @watcher.watchable
    )

    if watcher.valid? 
      watcher.save
    end

    watcher

  end

  def destroy!
    @watcher.destroy
  end

end
