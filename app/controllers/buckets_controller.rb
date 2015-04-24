class BucketsController < ApplicationController

  def create
    bucket = current_user.buckets.new(bucket_create_params)

    authorize bucket

    drop = bucket.drops.new(drop_create_params.merge({user_id: bucket.user_id}))

    if drop.valid? && bucket.valid? && drop.save && bucket.save

      json_response 201,
        success: true,
        message_id: 'shared_bucket_created',
        message: I18n.t('success.record_created'),
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
    bucket = Bucket.find(params[:id])

    authorize bucket
    
    if bucket.update(update_params)

        json_response 200,
          sucess: false,
          message_id: 'record_updated',
          message: I18n.t('success.record_updated'),
          data: { bucket: bucket } 

    else
      if bucket.errors
        json_response 400,
          sucess: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          data: { error: bucket.errors } 
      else
        raise CantSaveError
      end

    end

  end
  
  def destroy
  end

  private

  def bucket_create_params
    params.require(:bucket).permit(
      :title,
      :description,
    )
  end
  
  def drop_create_params
    params.require(:drop).permit(
      :media_key,
      :caption
    )
  end

  def update_params
    params.require(:bucket).permit(
      :description,
      :when_datetime,
      :visibility,
      :locked
    )
  end

end
