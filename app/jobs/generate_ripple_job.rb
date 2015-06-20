class GenerateRippleJob < ActiveJob::Base

  queue_as :generate_ripple

  def perform(record)

    @topic = record.topic
    
    if @topic.is_a?(Bucket) 
       
      if !@topic.user_bucket?

        each_subscriber do |s|
          RippleActions.new(
            ripple: Ripple.new(
              interaction: record,
              user: s.user
            )
          ).create!
        end

      end
    elsif @topic.is_a?(Drop)
      
      if @topic.bucket.user_bucket?
        each_subscriber do |s|
          RippleActions.new(
            ripple: Ripple.new(
              interaction: record,
              user: s.user
            )
          ).create!
        end
      else 
        each_watcher do |s|
          RippleActions.new(
            ripple: Ripple.new(
              interaction: record,
              user: s.user
            )
          ).create!
        end
      end 

    elsif @topic.is_a?(Tag)
      RippleActions.new(
        ripple: Ripple.new(
          interaction: record,
          user: @topic.taggee
        )
      ).create!
    elsif @topic.is_a?(Vote)
      RippleActions.new(
        ripple: Ripple.new(
          interaction: record,
          user: @topic.drop.user
        )
      ).create!
    elsif @topic.is_a?(Subscription)
      RippleActions.new(
        ripple: Ripple.new(
          interaction: record,
          user: @topic.subscribee
        )
      ).create!
    end

  end

  private

  def each_subscriber
    subscriptions = Subscription.where(subscribee: @topic.user)

    subscriptions.each do |s|
      yield s
    end
  end
  
  def each_watcher
    watchers = Watcher.where(watchable: @topic.bucket)

    watchers.each do |s|
      yield s
    end
  end

end
