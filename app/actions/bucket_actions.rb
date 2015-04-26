class BucketActions

  def initialize(bucket: nil, params: nil)
    @bucket = bucket
    @params = params
  end

  def create!(drop_create_params)
    
    drop = @bucket.drops.new(
      drop_create_params.merge({
        user_id: @bucket.user_id
      }))

    drop.save 
    @bucket.save

    [@bucket, drop]

  end

end
