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
              message: "#{@originator.username} created a new shared bucket #{@record.title}",
              trigger: record,
              triggee: @originator,
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
              message: "#{@originator.username} just added a drop to his bucket",
              trigger: record,
              triggee: @originator,
              user: s.user,
              pushable: true
            )
          ).create!
        end
      else 
        RippleActions.new(
          ripple: Ripple.new(
            message: "#{@originator.username} just added a drop to #{@record.bucket.title}",
            trigger: record,
            triggee: @originator,
            user: record.bucket.user,
            pushable: true
          )
        ).create!
      end 

    elsif record.is_a?(Tag)
      if record.taggable.is_a?(Bucket)
        message = "#{@originator.username} just tagged you in a bucket!"
      else
        message = "#{@originator.username} just tagged you in a drop!"
      end

      RippleActions.new(
        ripple: Ripple.new(
          message: message,
          trigger: record,
          triggee: @originator,
          user: record.taggee,
          pushable: true
        )
      ).create!
    elsif record.is_a?(Vote)
      RippleActions.new(
        ripple: Ripple.new(
          message: "#{@originator.username} set the temperature of your drop to #{@record.temperature} degrees!",
          trigger: record,
          triggee: @originator,
          user: record.drop.user,
          pushable: true
        )
      ).create!
    elsif record.is_a?(Subscription)
      RippleActions.new(
        ripple: Ripple.new(
          message: "#{@originator.username} is now subscribing to you!",
          trigger: record,
          triggee: @originator,
          user: record.subscribee,
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
