require 'rails_helper'

describe DropActions do

  describe "#create!" do

    context "including tags in the caption" do

#      it "parses the captions and calls create on each one" do
#        drop = FactoryGirl.build(:drop, :with_user_bucket)
#
#        drop = DropActions.new(
#          drop: drop,
#          param: { caption: "hello #oslo @miri come to #berlin" }
#        ).create!
#
#        expect(tag_actions).to receive(:create!).exactly(3).times
#      end

    end
  
  end

  describe "#vote!", focus: true do
      let!(:drop) { FactoryGirl.create(:drop, :with_shared_bucket) }
      let!(:vote) {
        DropActions.new(
          drop: drop,
          param: { temperature: 50 },
          user: drop.bucket.user
        ).vote!
      }

      it "saves new votes" do
        drop = FactoryGirl.create(:drop, :with_shared_bucket)
        expect{
          DropActions.new(
            drop: drop,
            param: { temperature: 50 },
            user: drop.bucket.user
          ).vote!
        }.to change(Vote, :count).by(1)
      end

      it "updates existing votes" do
      
        DropActions.new(
          drop: drop,
          param: { temperature: 25 },
          user: drop.bucket.user
        ).vote!

        expect(vote.reload.temperature).to eql(25)

      end

  end

  describe "#redrop!" do
    
   it "saves new redrops" do
      drop = FactoryGirl.create(:drop, :with_shared_bucket)
      bucket = FactoryGirl.create(:user_bucket, :with_user)

      expect{
        DropActions.new(
          drop: drop,
          user: bucket.user
        ).redrop!
      }.to change(Drop, :count).by(1)
   end 


  end

end
