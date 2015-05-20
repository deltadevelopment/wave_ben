class DropsController < ApplicationController
  after_action :verify_authorized

  def create
    bucket = Bucket.find(params[:bucket_id])
    drop = Drop.new(bucket: bucket, user: current_user)

    authorize drop

    drop = DropActions.new(drop: drop, param: create_params).create!

    if drop.persisted?
       json_response 201,
        success: true,
        message_id: 'record_created',
        message: I18n.t('success.record_created'),
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
    drop = Drop.find(params[:drop_id])

    authorize drop

    drop.destroy!

    json_response 204,
      success: true,
      message_id: 'resource_destroyed',
      message: I18n.t('success.resource_destroyed'),
      data: { drop: drop } 

  end 

  def generate_upload_url

    authorize Drop.new 

    url, key = aws_generate_upload_url

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

  private

  def create_params
    params.require(:drop).permit(:media_key, :media_type, :caption, :thumbnail_key)
  end

end
