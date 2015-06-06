require 'rails_helper'

describe Notification do

  it { should belong_to(:user) }
  it { should belong_to(:trigger) }
  it { should belong_to(:triggee) }

  describe "message format" do
    let(:notification) { FactoryGirl.create(:notification) }

    it "tests the tests" do
      expect(notification).to be_valid
    end
   
    it "is present" do
      notification.message = nil
      expect(notification).to_not be_valid
    end

  end

  describe "after_create callback" do
    let(:notification) { FactoryGirl.build(:drop_notification, pushable: true) }
    
    it "calls notify_user after create" do
      expect(notification).to receive(:notify_user)
      notification.save
    end

    it "calls notify on pushable notifications" do
      expect(notification.user).to receive(:notify)
      notification.save
    end

  end

end
