class TagActions

  def initialize(tag: nil, param: nil)
    @tag = tag
    @param = param
  end
    
  def create!
    tag_string, is_hashtag = process_tag(@tag.tag_string)

    bucket_type_taggable?

    if @tag.valid?
      set_taggee(tag_string, is_hashtag)

      update_exipiry!

      @tag.save unless @tag.taggee.nil?
    end

    @tag

  end

  private

  def bucket_type_taggable?
    if @tag.taggable.is_a?(Bucket) && @tag.taggable.bucket_type == 'user'
      @tag.errors.add(:bucket_type, "it's not possible to tag a user bucket")
    end
  end

  def set_taggee(tag_string, is_hashtag)
    @tag.taggee = is_hashtag ? 
      Hashtag.find_or_create_by(tag_string: tag_string) :
      User.find_by_username(tag_string)
  end

  def process_tag(tag_string)
    [tag_string[1..-1], tag_string[0] == "#"]
  end

  def update_exipiry!
    if @tag.taggee.is_a?(Hashtag)
      @tag.taggee.update_attributes(expires: 7) unless @tag.taggee.new_record?
    end
  end

end
