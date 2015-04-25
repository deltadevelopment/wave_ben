require 'rails_helper'

describe UserSession do

  let(:user) { FactoryGirl.create(:user) }

  describe "#generate_token" do

    it "returns a token" do
      token = UserSession.new.generate_token(user.id).auth_token
      expect(token).to_not be_nil
    end
    
    it "returns a different token each time" do
      # This test does not rule out duplicates
      token = UserSession.new.generate_token(user.id).auth_token
      token2 = UserSession.new.generate_token(user.id).auth_token
      expect(token).to_not be_equal(token2)
    end

  end

end