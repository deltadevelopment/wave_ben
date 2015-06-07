require 'rails_helper'

describe RippleActions do
  
  describe "#create!" do
    let(:ripple) { FactoryGirl.build(:bucket_ripple) }
    
    it "saves the record" do
      expect{
        RippleActions.new(ripple: ripple).create!
      }.to change(Ripple, :count).by(1)
    end 

  end

end
