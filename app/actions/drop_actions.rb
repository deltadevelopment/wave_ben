class DropActions

  def initialize(drop: nil, param: nil)
    @drop = drop
    @param = param
  end

  def create!
    
    @drop.media_key = @param[:media_key]
    @drop.media_type = @param[:media_type]
    @drop.caption = @param[:caption]
    
    if @drop.caption
      create_tags(parse_caption(@drop.caption))
    end

    @drop.save
    
    @drop
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
