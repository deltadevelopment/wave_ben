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
            bucket, :add, bucket.user.subscribers[0].user
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
            drop, :add_drop_to_userbucket, drop.bucket.user
          )
        }.to change(Ripple, :count).by(1)
      end

      it "notifies the owner of a shared bucket that a new drop 
          has been added" do
        drop = FactoryGirl.create(:drop, :with_user_with_subscriber, 
                                  :with_shared_bucket)

        expect{
          GenerateRippleJob.new.perform(
            drop, :add_drop_to_shared_bucket, drop.user
          )
        }.to change(Ripple, :count).by(1)
      end

    end

    context "when record is a tag" do

      it "notifies the taggee when a usertag is added" do
        tag = FactoryGirl.create(:usertag)

        expect{
          GenerateRippleJob.new.perform(
            tag, :add_usertag, tag.taggable.user
          )
        }.to change(Ripple, :count).by(1)
      end

    end

  end

end
