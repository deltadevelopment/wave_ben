class BucketsController < ApplicationController

  def create
    bucket = current_user.buckets.new(create_params.except :media_key)
    media_key = create_params.fetch :media_key

    authorize bucket

    drop = bucket.drops.new({
      media_key: media_key,
      user_id: current_user.id 
    })

    if drop.valid? && bucket.valid? && drop.save && bucket.save
      
      json_response 201,
        success: true,
        message_id: 'shared_bucket_created',
        message: I18n.t('success.shared_bucket_created'),
        data: {
          bucket: bucket,
          drop: drop
        }

    else
      errors = bucket.errors.messages.merge(drop.errors.messages)

      if errors
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          data: { error: errors  }
      else
        raise CantSaveError
      end      

    end

  end

  def update
  end
  
  def destroy
  end

  private

  def create_params
    params.require(:bucket).permit(
      :title,
      :description,
      :media_key,
      :caption
    )
  end

end
