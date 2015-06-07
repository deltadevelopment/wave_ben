require 'rails_helper'

describe Ripple do

  it { should belong_to(:user) }
  it { should belong_to(:trigger) }
  it { should belong_to(:triggee) }

  describe "message format" do
    let(:ripple) { FactoryGirl.create(:ripple) }

    it "tests the tests" do
      expect(ripple).to be_valid
    end
   
    it "is present" do
      ripple.message = nil
      expect(ripple).to_not be_valid
    end

  end

  describe ".get_ripples" do
    let(:user) { FactoryGirl.create(:user) }

    it "updates seen_at" do
      FactoryGirl.create_list(:bucket_ripple, 2, user: user)

      ripples = Ripple.get_new_ripples(user)
      expect(ripples[0].reload.seen_at).to_not be_nil
    end
  end

  describe "after_create callback" do
    let(:ripple) { FactoryGirl.build(:drop_ripple, pushable: true) }
    
    it "calls notify_user after create" do
      expect(ripple).to receive(:notify_user)
      ripple.save
    end

    it "calls notify on pushable notifications" do
      expect(ripple.user).to receive(:notify)
      ripple.save
    end

  end

end
