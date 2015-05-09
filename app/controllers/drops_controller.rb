class DropsController < ApplicationController

  def create
    bucket = Bucket.find(params[:bucket_id])
    drop = Drop.new(bucket: bucket, user: current_user)

    authorize drop

    drop = DropActions.new(drop, params).create! 

    if drop.persisted?
       json_response 201,
        success: true,
        message_id: 'resource_created',
        message: I18n.t('success.resource_created'),
        data: { drop: drop }
    else
      unless drop.errors.empty?
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          errors: drop.errors
      else
        raise CantSaveError
      end

    end

  end

  def destroy
  end

  def generate_upload_url

    authorize Drop.new 

    s3 = Aws::S3::Resource.new
    key = SecureRandom::hex(40)
    
    obj = s3.bucket(ENV['S3_BUCKET']).object(key)
    url = URI::parse(obj.presigned_url(:put))

    json_response 200,
      success: true,
      message_id: 'upload_url_generated',
      message: I18n.t('success.upload_url_generated'),
      data: {
        upload_url: {
          url: url.to_s,
          media_key: key
        }
      }

  end

end
