class TagActions

  def initialize(tag: nil, param: nil)
    @tag = tag
    @param = param
  end
    
  def create!
    tag_string, is_hashtag = process_tag(@param[:tag_string])

    if @tag.taggable.bucket_type == 'user'
      @tag.errors.add(:bucket_type, "it's not possible to tag a user bucket")
    elsif @tag.valid?
      @tag.taggee = is_hashtag ? 
        Hashtag.find_or_create_by(tag_string: tag_string) :
        User.find_by_username(tag_string)

      @tag.taggee.update_attributes(expires: 7) unless @tag.taggee.new_record?
      
      @tag.save
    end

    @tag

  end

  def process_tag(tag_string)
    [tag_string[1..-1], tag_string[0] == "#"]
  end

end
