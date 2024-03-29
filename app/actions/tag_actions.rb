class TagActions

  def initialize(tag: nil, param: nil)
    @tag = tag
    @param = param
  end
    
  def create!

    if @tag.valid?
      tag_string, is_hashtag = process_tag(@tag.tag_string)

      set_taggee(tag_string, is_hashtag)

      if @tag.taggable.is_a?(Bucket) && !is_hashtag
        if @tag.taggable.everyone?
          change_bucket_visibility
          change_watchers
        else

        end
      end

      update_exipiry_and_counter_cache!

      @tag.save unless @tag.taggee.nil?

      # TODO: Could this be generalized into serving both
      # UserTags and BucketTags?
      if @tag.taggee.is_a?(User)
        InteractionActions.new(
          interaction: Interaction.new(
            user: @tag.taggable.user,
            topic: @tag,
            action: @tag.taggable.is_a?(Drop) ? "create_tag_drop" : "create_tag_bucket"
          )
        ).create!
      end
    end

    @tag

  end

  def destroy!
    @tag.destroy!
    
    @tag.taggable.drops.where(user: @tag.taggee).each(&:destroy)

    if @tag.taggable.is_a?(Bucket) && @tag.taggee.is_a?(User) && !has_taggees(@tag.taggable) && @tag.taggable.taggees?
      @tag.taggable.update(visibility: :everyone)
    end

  end

  private

  def change_bucket_visibility
    @tag.taggable.visibility = :taggees
    @tag.taggable.save
  end

  # Delete all the current watchers, and adds the owner and the newly created
  # taggee
  def change_watchers
    @tag.taggable.watchers.each(&:destroy)
    @tag.taggable.watchers.create(user: @tag.taggable.user)
    @tag.taggable.watchers.create(user: @tag.taggee)
  end
  

  def has_taggees(taggable)
    taggable.tags.count > 0 
  end

  def set_taggee(tag_string, is_hashtag)
    @tag.taggee = is_hashtag ? 
      Hashtag.find_or_create_by(tag_string: tag_string) :
      User.find_by_username(tag_string)
  end

  def process_tag(tag_string)
    [tag_string[1..-1], tag_string[0] == "#"]
  end

  def update_exipiry_and_counter_cache!
    if !@tag.taggee.new_record? && @tag.taggee.is_a?(Hashtag)
      @tag.taggee.tags_count += 1
      @tag.taggee.expires = 7
    end
  end

end
