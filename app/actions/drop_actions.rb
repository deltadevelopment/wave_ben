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

    @drop.save
    
    @drop
  end

  def vote!
    vote = Vote.find_or_create_by(
      user: @user,
      drop: @drop, 
      bucket: @drop.bucket
    )

    vote.temperature = @param[:temperature]
    
    vote.save

    vote

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
