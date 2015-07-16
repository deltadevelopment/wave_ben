require 'rails_helper'

describe VotePolicy do

  subject { described_class }

  let(:vote) { FactoryGirl.create(:vote) }

  permissions :destroy? do
    it "allows the owner to destroy the bucket" do
      expect(subject).to permit(vote.user, vote)
    end

    it "does not allow random users to destroy the bucket" do
      expect(subject).to_not permit(FactoryGirl.create(:user), vote)
    end
  end

end
