class GenerateNotificationJob < ActiveJob::Base

  queue_as :generate_notification

  def perform(record, action, originator)
    
    if record.is_a?(Bucket) 
       
      if record.user_bucket?
        Subscription.where(user: originator)   
      else
        # Shared bucket
      end

    elsif record.is_a?(Drop)

    end

  end

end
