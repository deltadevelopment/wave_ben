class DeleteEmptyBucketsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Bucket.where(drops_count: 0, bucket_type: 0).each(&:destroy)
  end
end
