require 'rails_helper'

describe UserPolicy do

  subject { described_class }

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }

  permissions :update? do

    it "allows the owner to update his profile" do
      expect(subject).to permit(user, user)
    end

    it "does not allow users to update other peoples profiles" do
      expect(subject).to_not permit(user2, user)
    end

  end

  permissions :destroy? do

    it "allows the owner to update his profile" do
      expect(subject).to permit(user, user)
    end

    it "does not allow users to update other peoples profiles" do
      expect(subject).to_not permit(user2, user)
    end

  end

end
