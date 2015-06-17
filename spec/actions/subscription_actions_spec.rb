require 'rails_helper'

describe SubscriptionActions do

  describe "#create!" do
    let(:subscription) { FactoryGirl.build(:subscription) }

    it "saves the record" do
      expect{
        SubscriptionActions.new(subscription: subscription).create!
      }.to change(Subscription, :count).by(1)
    end

    it "does not save duplicate records" do
      SubscriptionActions.new(subscription: subscription).create!
      expect{
        SubscriptionActions.new(subscription: subscription).create!
      }.to change(Subscription, :count).by(0)
    end

    it "queues a GenerateRippleJob" do
      expect(GenerateRippleJob).to receive(:perform_later)

      SubscriptionActions.new(subscription: subscription).create!
    end

  end

end
