class BucketActions

  def initialize(bucket: nil, params: nil)
    @bucket = bucket
    @params = params
  end

  def create!(drop_create_params)

    @bucket.save
    
    drop = DropActions.new(
      drop: Drop.new(drop_create_params.merge({
        user_id: @bucket.user_id,
        bucket_id: @bucket.id
      })),
      param: @params[:drop]
    ).create!

    [@bucket, drop]

  end

end
