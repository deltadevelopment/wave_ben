class GenerateRippleJob < ActiveJob::Base

  queue_as :generate_ripple

  def perform(record)
    @topic = record.topic

    case record.action

    when "create_bucket"
      each_subscriber do |s|
        RippleActions.new(
          ripple: Ripple.new(
            interaction: record,
            user: s.user
          )
        ).create!
      end
    when "create_subscription"
      RippleActions.new(
        ripple: Ripple.new(
          interaction: record,
          user: @topic.subscribee
        )
      ).create!
    when "create_drop_user_bucket"
      each_subscriber do |s|
        RippleActions.new(
          ripple: Ripple.new(
            interaction: record,
            user: s.user
          )
        ).create!
      end
    when "create_drop_shared_bucket"
      each_watcher do |s|
        unless record.user == s.user
          RippleActions.new(
            ripple: Ripple.new(
              interaction: record,
              user: s.user
            )
          ).create!
        end
      end
    when "create_redrop"
      RippleActions.new(
        ripple: Ripple.new(
          interaction: record,
          user: @topic.drop_id.user
        )
      ).create!
    when "create_vote"
      RippleActions.new(
        ripple: Ripple.new(
          interaction: record,
          user: @topic.drop.user
        )
      ).create!
    when "create_tag_drop"
      RippleActions.new(
        ripple: Ripple.new(
          interaction: record,
          user: @topic.taggee
        )
      ).create!
    when "create_tag_bucket"
      RippleActions.new(
        ripple: Ripple.new(
          interaction: record,
          user: @topic.taggee
        )
      ).create!
    when "create_chat_message"
      each_watcher do |w|
        if !record.users_watching.include?(w.user.id)
          RippleActions.new(
            ripple: Ripple.new(
              interaction: record,
              user: w.user
            )
          ).create!
        end
      end
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
    # TODO: Temporary fix
    watchers = @topic.is_a?(Drop) ? 
      Watcher.where(watchable: @topic.bucket) : Watcher.where(watchable: @topic)


    watchers.each do |s|
      yield s
    end
  end

end
