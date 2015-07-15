require 'rails_helper'

describe Vote do

  it { should belong_to(:user) }
  it { should belong_to(:drop) }
  it { should belong_to(:bucket) }
  it { should have_many(:interactions).dependent(:destroy) }

  describe "vote format" do
    let(:vote) { Vote.new(vote: 1) }
    
    it "tests the tests" do
      expect(vote).to be_valid
    end

    it "does not allow votes without vote" do
      vote.vote = nil
      expect(vote).to_not be_valid
    end

  end

  describe "#increment_counter_cache" do
    it "gets called on create" do
      vote = FactoryGirl.build(:vote)
      expect(vote).to receive(:increment_counter_cache)
      vote.save
    end

    it "changes the count" do
      vote = FactoryGirl.create(:vote, vote: 1)
      expect(vote.drop.reload.vote_one_count).to eq(1)
    end
  end

end
