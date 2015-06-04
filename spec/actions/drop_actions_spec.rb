require 'rails_helper'

describe DropActions do

  describe "#create!" do
    let(:drop) { FactoryGirl.build(:drop, :with_shared_bucket) }
    let(:param) {
      { 
        media_key: 'A'*64,
        media_type: 0
      }
    }

    it "adds a watcher drops you create" do
      expect{
        DropActions.new(drop: drop, param: param).create! 
      }.to change(Watcher, :count).by(1)
    end

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

      context "when voting on a re-drop" do
        let(:redrop) { FactoryGirl.create(
          :drop, 
          :with_user_bucket, 
          :as_redrop
        ) }

        it "the vote references the original drop" do
          vote = DropActions.new(
            drop: redrop,
            param: { temperature: 25 },
            user: redrop.bucket.user
          ).vote!
          expect(vote.drop.id).to eql(redrop.original_drop.id)
        end

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
