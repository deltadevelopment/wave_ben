class WatcherActions

  def initialize(watcher: nil, param: nil)
    @watcher = watcher
    @param   = param
  end

  def create!
    
    if @watcher.valid? 
      @watcher.save
    end

    @watcher

  end

  def destroy!
    @watcher.destroy
  end

end
