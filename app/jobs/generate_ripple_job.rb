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
              message: "#{originator} created a new shared bucket!",
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
              message: "#{originator} just added a drop to his bucket",
              trigger: record,
              triggee: originator,
              user: s.user,
              pushable: true
            )
          ).create!
        end
      end 

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
