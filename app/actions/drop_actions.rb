class DropActions

  def initialize(drop: nil, param: nil)
    @drop = drop
    @param = param
  end

  def create!
    
    @drop.media_key = @param[:media_key]
    @drop.caption = @param[:caption]

    # Parse caption to find tags
         
    if @drop.bucket.bucket_type == 'user'
      parent_id = Drop.where(
        "bucket_id=? AND user_id=?", @drop.bucket.id, @drop.bucket.user_id
      ).order(created_at: :desc).pluck(:id).first
      @drop.parent_id = parent_id unless @drop.user.is_owner?(@drop.bucket)
    end

    @drop.save
    
    @drop
  end

end
