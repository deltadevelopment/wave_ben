class TagsController < ApplicationController
  after_action :verify_authorized

  def list
    tags = Tag.where(taggable_type: 'Bucket', taggable_id: params[:bucket_id])

    authorize tags.take!

    json_response 200,
      success: true,
      message: I18n.t('success.ok'),
      message_id: 'ok',
      data: ActiveModel::ArraySerializer.new(
        tags,
        each_serializer: TagSerializer,
        root: "tags"
      )

  end

  def create
    bucket = Bucket.find(params[:bucket_id])
    tag = Tag.new(
      taggable: bucket,
      tag_string: create_params[:tag_string],
    ) 
    
    # TODO Rewrite this to some other syntax
    authorize tag

    tag = TagActions.new(
      tag: tag
    ).create!

    if tag.persisted?
      json_response 201,
        success: true,
        message_id: "record_created",
        message: I18n.t('success.record_created'),
        data: { tag: tag }
    else
      if tag.errors
        json_response 400,
          success: false,
          message_id: "validation_error",
          message: I18n.t('error.validation_error'),
          errors: tag.errors
      else
        raise CantSaveError
      end
    end

  end

  def destroy
    tag = Tag.find(params[:tag_id])

    authorize tag

    tag = TagActions.new(tag: tag).destroy!

    json_response 204,
      success: true,
      message_id: "record_destroyed",
      message: I18n.t('success.record_destroyed'),
      data: { tag: tag }

  end

  private

  def create_params
    params.require(:tag).permit(:tag_string)
  end

end
