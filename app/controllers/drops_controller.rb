class DropsController < ApplicationController

  def create
    bucket = Bucket.find(params[:id])

    authorize bucket

  end

  def destroy
  end

  def generate_upload_url

    authorize Drop.new 

    s3 = Aws::S3::Resource.new
    key = SecureRandom::hex(40)
    
    obj = s3.bucket(ENV['S3_BUCKET']).object(key)
    url = URI::parse(obj.presigned_url(:put))

    json_response 201,
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
