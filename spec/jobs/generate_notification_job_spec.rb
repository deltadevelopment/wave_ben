require 'rails_helper'

describe GenerateNotificationJob do

  describe "#perform" do
    
    context "when record is a shared bucket" do
      let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user_with_subscriber) }

      it "notifies subscribers of new shared buckets created" do
        expect{
          GenerateNotificationJob.new.perform(
            bucket, :add, bucket.user.subscribers[0].user
          )
        }.to change(Notification, :count).by(1)
      end 
    end

    context "when record is a drop" do

      it "notifies subscribers of new userdrops added" do
        drop = FactoryGirl.create(:drop, :with_user_with_subscriber, :with_user_bucket)

        expect{
          GenerateNotificationJob.new.perform(
            drop, :add_drop_to_userbucket, drop.bucket.user
          )
        }.to change(Notification, :count).by(1)
      end

    end

  end

end
