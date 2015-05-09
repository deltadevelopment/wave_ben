require 'rails_helper'

describe SubscriptionPolicy do
  
  subject { described_class }

  permissions :create? do
    let(:user) { FactoryGirl.create(:user) }

    it "allows users to create new subscriptions" do
      expect(subject).to permit(user, Subscription.new(user: user))
    end 

    it "does not allow users to create subscriptions for others" do
      expect(subject).to_not permit(user, Subscription.new(user: User.new))
    end

  end

  permissions :destroy? do
    let(:user) { FactoryGirl.create(:user) }
    let(:subscribee) { FactoryGirl.create(:user) }

    it "allows users to delete their subscriptions" do
      expect(subject).to permit(user, Subscription.new(user: user))
    end

    it "does not allow users to delete other users subscriptions" do
      expect(subject).to_not permit(User.new, Subscription.new(user: user))
    end

  end
  

end
