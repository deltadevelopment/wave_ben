require 'rails_helper'

describe RippleActions do
  
  describe "#create!" do
    let(:ripple) { FactoryGirl.build(:bucket_ripple) }
    
    it "saves the record" do
      expect{
        RippleActions.new(ripple: ripple).create!
      }.to change(Ripple, :count).by(1)
    end 

    it "finds existing ones and updates them" do
      RippleActions.new(ripple: ripple).create!

      expect{
        RippleActions.new(
          ripple: Ripple.new(
            message: ripple.message,
            trigger: ripple.trigger,
            triggee: FactoryGirl.create(:user),
            pushable: ripple.pushable
          )
        ).create!
      }.to change(Ripple, :count).by(0)

    end

    it "does not update seen items" do
      RippleActions.new(ripple: ripple).create!

      expect{
        RippleActions.new(
          ripple: Ripple.new(
            message: ripple.message,
            trigger: ripple.trigger,
            triggee: FactoryGirl.create(:user),
            pushable: ripple.pushable
          )
        ).create!
      }.to change(Ripple, :count).by(0)
    end

  end

end
