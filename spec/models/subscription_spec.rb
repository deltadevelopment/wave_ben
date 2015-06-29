require 'rails_helper'

describe Subscription do
   
  it { should belong_to(:user) }
  it { should belong_to(:subscribee) }
  it { should have_many(:interactions).dependent(:destroy) }

  describe "counter cache" do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }

    it "adding a subscription increases the subscriber count" do
      subscription = Subscription.create(user: user, subscribee: user2)
      expect(user2.subscribers_count).to eq(1)
    end

    it "adding a subscription increases the subscribee count" do
      subscription = Subscription.create(user: user, subscribee: user2)
      expect(user.subscriptions_count).to eq(1)
    end

  end

end
