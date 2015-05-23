require 'rails_helper'

describe Vote do

  describe "temperature format" do
    let(:vote) { Vote.new(temperature: 50) }
    
    it "tests the tests" do
      expect(vote).to be_valid
    end

    it "does not allow votes without temperature" do
      vote.temperature = nil
      expect(vote).to_not be_valid
    end

  end

end
