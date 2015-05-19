class BucketActions

  def initialize(bucket: nil, params: nil)
    @bucket = bucket
    @params = params
  end

  def create!(drop_create_params)
    
    drop = DropActions.new(
      drop: Drop.new(drop_create_params.merge({
        user_id: @bucket.user_id
      })),
      param: @params[:drop]
    ).create!

    @bucket.save

    [@bucket, drop]

  end

end
