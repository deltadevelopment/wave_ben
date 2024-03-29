class DeleteOldDropsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Drop.where('created_at < ?', DateTime.now-48.hours).each(&:destroy)
  end
end
