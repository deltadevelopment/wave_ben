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
              action: "create"
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
              action: "create"
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
              action: "create"
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
              action: "create"
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
              action: "create"
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
              action: "create"
            )
          )
        }.to change(Ripple, :count).by(1)
      end

    end
  end

end
