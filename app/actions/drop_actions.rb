class DropActions

  def initialize(drop: nil, param: nil, user: nil)
    @drop = drop
    @param = param
    @user = user
  end

  def create!
    @drop.media_key = @param[:media_key]
    @drop.media_type = @param[:media_type]
    @drop.caption = @param[:caption]
    @drop.thumbnail_key = @param[:thumbnail_key]
    
    if @drop.caption
      create_tags(parse_caption(@drop.caption))
    end

    if @drop.save
      @drop.bucket.update(updated_at: DateTime.now)

      WatcherActions.new(
        watcher: Watcher.new(watchable: @drop, user: @drop.user)).create!
      InteractionActions.new(
        interaction: Interaction.new(
          user: @drop.user,
          topic: @drop,
          action: 
            @drop.bucket.user_bucket? ? 
              "create_drop_user_bucket" : "create_drop_shared_bucket"
        )
      ).create!
    end
    
    @drop
  end

  def vote!
    drop = @drop.original_drop ? @drop.original_drop : @drop

    vote = Vote.find_or_create_by(
      user: @user,
      drop: drop,
      bucket: @drop.bucket
    )

    vote.temperature = @param[:temperature]
    
    # You cant vote on your own drops 
    if vote.drop.user != vote.user
      if vote.save
          InteractionActions.new(
            interaction: Interaction.new(
              user: vote.user,
              topic: vote,
              action: "create_vote"
            )
          ).create!
      end
    end

    vote

  end

  def redrop!
    drop = Drop.new(
      media_key: @drop.media_key,
      media_type: @drop.media_type,
      thumbnail_key: @drop.thumbnail_key,
      caption: nil, 
      bucket_id: @user.user_bucket.take!.id,
      user_id: @user.id,
      temperature: -1,
      drop_id: @drop.drop_id.nil? ? @drop.id : @drop.drop_id
    )
    
    drop.save

    drop.bucket.update(updated_at: DateTime.now)

    InteractionActions.new(
      interaction: Interaction.new(
        user: @user,
        topic: drop,
        action: "create_redrop"
      )
    ).create!

    drop
  end

  private

  def parse_caption(caption)
    hashtags = caption.scan /#[a-z]\w*/
    usertags = caption.scan /@\w*/

    tags = hashtags.concat usertags
  end

  def create_tags(tags)
    tags.each do |tag|
      saved_tag = TagActions.new(
        tag: Tag.new(taggable: @drop, tag_string: tag)
      ).create!
    end
  end

end
