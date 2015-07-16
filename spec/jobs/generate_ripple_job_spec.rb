require 'rails_helper'

describe GenerateRippleJob do

  describe "#perform" do
    
    context "when record is a shared bucket" do
      let(:bucket) { FactoryGirl.create(:shared_bucket, 
                                        :with_user_with_subscriber)
      }

      it "notifies subscribers of new shared buckets created" do
        expect{
          GenerateRippleJob.new.perform(
            Interaction.create( 
              user: bucket.user,
              topic: bucket,
              action: "create_bucket"
            )
          )
        }.to change(Ripple, :count).by(1)
      end 
    end

    context "when record is a drop" do

      it "notifies subscribers of new userdrops added" do
        drop = FactoryGirl.create(:drop, :with_user_with_subscriber, 
                                  :with_user_bucket)

        expect{
          GenerateRippleJob.new.perform(
            Interaction.create( 
              user: drop.user,
              topic: drop,
              action: "create_drop_user_bucket"
            )
          )
        }.to change(Ripple, :count).by(1)
      end

      it "notifies the watcher of a shared bucket that a new drop 
          has been added" do
        bucket = FactoryGirl.create(:shared_bucket, :with_drop, :with_watcher)

        expect{
          GenerateRippleJob.new.perform(
            Interaction.create( 
              user: bucket.drops[0].user,
              topic: bucket.drops[0],
              action: "create_drop_shared_bucket"
            )
          )
        }.to change(Ripple, :count).by(1)
      end

    end

    context "when record is a tag" do

      it "notifies the taggee when a usertag is added" do
        tag = FactoryGirl.create(:usertag)

        expect{
          GenerateRippleJob.new.perform(
            Interaction.create( 
              user: FactoryGirl.create(:user),
              topic: tag,
              action: "create_tag_drop"
            )
          )
        }.to change(Ripple, :count).by(1)
      end

    end

    context "when record is a vote" do

      it "notifies the owner of a drop when a vote is cast" do
        vote = FactoryGirl.create(:vote)

        expect{
          GenerateRippleJob.new.perform(
            Interaction.create( 
              user: vote.user,
              topic: vote,
              action: "create_vote"
            )
          )
        }.to change(Ripple, :count).by(1)
      end

    end

    context "when record is a subscriber" do

      it "notifies the subscribee when a subscription is created" do
        subscription = FactoryGirl.create(:subscription)

        expect{
          GenerateRippleJob.new.perform(
            Interaction.create( 
              user: subscription.user,
              topic: subscription,
              action: "create_subscription"
            )
          )
        }.to change(Ripple, :count).by(1)
      end

    end

    context "when posting a chat message" do
      let(:bucket) { FactoryGirl.create(:shared_bucket, :with_watcher) }

      it "only notifies those that are not watching" do
        user = FactoryGirl.create(:user)
        watcher = FactoryGirl.create(:bucket_watcher, watchable: bucket)
        FactoryGirl.create(:bucket_watcher, watchable: bucket)

        expect{
          GenerateRippleJob.new.perform(
            Interaction.create( 
              user: user,
              topic: bucket,
              action: "create_chat_message",
            ),
            { "users_watching" => [watcher.user.id] }
          )
          # The owner, and a separate watcher = 2
        }.to change(Ripple, :count).by(2)
      end


    end
    
  end

end
