class BucketsController < ApplicationController
  after_action :verify_authorized

  def show
    bucket = Bucket.find(params[:bucket_id])
    
    authorize bucket

    json_response 200,
      success: true,
      message: I18n.t('success.ok'),
      message_id: 'ok',
      data: BucketSerializer.new(bucket, scope: current_user)
  end

  def create
    authorize Bucket.new

    bucket, drop = BucketActions.new(
      bucket: current_user.buckets.new(bucket_create_params),
      param: params.merge({drop: drop_create_params})
    ).create!

    if bucket.persisted? && drop.persisted?

      json_response 201,
        success: true,
        message_id: 'record_created',
        message: I18n.t('success.record_created'),
        data: {
          bucket: bucket,
          drop: drop
        }

    else
      errors = bucket.errors.messages.merge(drop.errors.messages)

      unless errors.empty?
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          errors: errors
      else
        raise CantSaveError
      end      

    end

  end

  def update
    bucket = Bucket.find(params[:bucket_id])

    authorize bucket
    
    if bucket.update(update_params)

        json_response 200,
          sucess: false,
          message_id: 'record_updated',
          message: I18n.t('success.record_updated'),
          data: { bucket: bucket } 

    else
      unless bucket.errors.empty?
        json_response 400,
          sucess: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          errors: bucket.errors
      else
        raise CantSaveError
      end

    end

  end
  
  def destroy
    bucket = Bucket.find(params[:bucket_id])

    authorize bucket

    bucket.destroy!

    json_response 204,
      sucess: false,
      message_id: 'record_destroyed',
      message: I18n.t('success.record_destroyed'),
      data: { bucket: bucket } 
  end

  def watch
    bucket = Bucket.find(params[:bucket_id])

    authorize bucket

    watcher = WatcherActions.new(
      watcher: Watcher.new(
          user: current_user,
          watchable: bucket)
    ).create!
    
    if watcher.persisted?
      json_response 201,
          success: true,
          message: I18n.t('success.ok'),
       message_id: 'ok',
             data: { watcher: watcher }
    else
      unless watcher.errors.empty?
        json_response 400,
            success: false,
            message: I18n.t('error.validation_error'),
         message_id: 'validation_error',
             errors: watcher.errors
      end
    end
  end

  def unwatch
    bucket = Bucket.find(params[:bucket_id])
    watcher = Watcher.where(watchable: bucket, user: current_user).take!

    authorize watcher 

    watcher = WatcherActions.new(watcher: watcher).destroy!

    if watcher.destroyed?
      json_response 204,
        success: true
    else
      raise CantDestroyError
    end

  end

  def list_watchers
    bucket = Bucket.find(params[:bucket_id])
    watchers = Watcher.where(watchable: bucket, user: current_user)
    
    # TODO: IMPLEMENT AUTHORIZATION HERE!
    authorize watchers.take!

    json_response 200,
      success: true,
      message: I18n.t('success.ok'),
      message_id: 'ok',
      data: ActiveModel::ArraySerializer.new(
        watchers,
        each_serializer: WatcherSerializer,
        root: "watchers"
      )
  end

  def buckets_for_user
    user = User.find(params[:user_id])
    buckets = Bucket.where(user_id: user.id)

    authorize buckets.take!

    buckets = remove_inacessible_tagged_buckets(buckets)
    
    json_response 200,
      success: true,
      message: I18n.t('success.ok'),
      message_id: 'ok',
      data: ActiveModel::ArraySerializer.new(
        buckets,
        each_serializer: FeedSerializer,
        root: "buckets"
      )
  end
  
  private

  def remove_inacessible_tagged_buckets(buckets)
    buckets.select { |b| user_is_taggee_or_owner(b) }
  end

  def user_is_taggee_or_owner(bucket)
    bucket.everyone? || current_user == bucket.user || 
      bucket.tags.where(taggee: current_user).take
  end

  def bucket_create_params
    params.require(:bucket).permit(
      :title,
    )
  end
  
  def drop_create_params
    params.require(:drop).permit(
      :media_key,
      :media_type,
      :thumbnail_key,
      :caption
    )
  end

  def update_params
    params.require(:bucket).permit(
      :title
    )
  end

end
