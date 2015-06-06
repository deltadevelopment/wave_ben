require 'rails_helper'

describe NotificationActions do
  
  describe "#create!" do
    let(:notification) { FactoryGirl.build(:bucket_notification) }
    
    it "saves the record" do
      expect{
        NotificationActions.new(notification: notification).create!
      }.to change(Notification, :count).by(1)
    end 

  end

end


