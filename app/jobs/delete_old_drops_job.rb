class DeleteOldDropsJob < ActiveJob::Base
  queue_as :delete_old_drops

  def perform(*args)
    drops = Drop.where('created_at < ?', DateTime.now-24.hours).each(&:destroy)
  end
end
