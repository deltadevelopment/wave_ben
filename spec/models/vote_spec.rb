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

end
