class BucketActions

  def initialize(bucket: nil, param: nil)
    @bucket = bucket
    @param = param
  end

  def create!

    @bucket.save!

    WatcherActions.new(
      watcher: Watcher.new(watchable: @bucket, user_id: @bucket.user_id)
    ).create!
    
    InteractionActions.new(
      interaction: Interaction.new(
        user: @bucket.user,
        topic: @bucket,
        action: "create_bucket"
      )
    ).create!

    drop = DropActions.new(
      drop: Drop.new(@param[:drop].merge({
        user_id: @bucket.user_id,
        bucket_id: @bucket.id
      })),
      param: @param[:drop]
    ).create!

    [@bucket, drop]

  end

end
