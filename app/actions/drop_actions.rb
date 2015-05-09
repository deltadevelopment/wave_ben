class DropActions

  def initialize(drop, param)
    @drop = drop
    @param = param
  end

  def create!
    
    @drop.media_key = @param[:media_key]
    @drop.caption = @param[:caption]

    # Parse caption to find tags
         
    if @drop.bucket.bucket_type == 'user'
      Drop.where(
        "bucket_id=? AND user_id=?", @drop.bucket.id, @drop.bucket.user_id
      ).order(created_at: :desc)
    end

    @drop.save
    
    @drop
  end

end
