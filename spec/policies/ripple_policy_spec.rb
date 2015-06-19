require 'rails_helper'

describe RipplePolicy do

  subject { described_class }

  permissions :list? do
    let(:ripple) { FactoryGirl.create(:drop_ripple) }
    
    it "allows the owner to see his Ripples" do
      expect(subject).to permit(ripple.user, ripple)
    end

    it "does not allow any user to view other users ripples" do
      expect(subject).to_not permit(User.new, ripple)
    end

  end

  permissions :create? do
    let(:ripple) { FactoryGirl.build(:drop_ripple) }

    it "does not allow normal users to create new ripples" do
      expect(subject).to_not permit(ripple.user, ripple)
    end

  end

end
