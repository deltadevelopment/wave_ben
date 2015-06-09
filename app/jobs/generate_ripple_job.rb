class GenerateRippleJob < ActiveJob::Base

  queue_as :generate_ripple

  def perform(record, action, originator)

    @record = record
    @action = action
    @originator = originator
    
    if record.is_a?(Bucket) 
       
      if !record.user_bucket?

        each_subscriber do |s|
          RippleActions.new(
            ripple: Ripple.new(
              message: "#{originator.username} created a new shared bucket!",
              trigger: record,
              triggee: originator,
              user: s.user,
              pushable: true
            )
          ).create!
        end

      end
    elsif record.is_a?(Drop)
      
      if record.bucket.user_bucket?
        each_subscriber do |s|
          RippleActions.new(
            ripple: Ripple.new(
              message: "#{originator.username} just added a drop to his bucket",
              trigger: record,
              triggee: originator,
              user: s.user,
              pushable: true
            )
          ).create!
        end
      end 

    elsif record.is_a?(Tag)
      if record.taggable.is_a?(Bucket)
        message = "#{originator.username} just tagged you in a bucket!"
      else
        message = "#{originator.username} just tagged you in a drop!"
      end

      RippleActions.new(
        ripple: Ripple.new(
          message: message,
          trigger: record,
          triggee: originator,
          user: record.taggee,
          pushable: true
        )
      ).create!
    end

  end

  private

  def each_subscriber
    subscriptions = Subscription.where(subscribee: @record.user)

    subscriptions.each do |s|
      yield s
    end
  end

end
