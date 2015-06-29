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

    it "saves an interaction" do
      expect{
        SubscriptionActions.new(subscription: subscription).create!
      }.to change(Interaction, :count).by(1)
    end

  end

end
