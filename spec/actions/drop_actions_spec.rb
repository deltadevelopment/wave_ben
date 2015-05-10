require 'rails_helper'

describe DropActions do

  describe "#create!" do
    
    it "sets the proper parent_id for drops in user buckets" do
      bucket = FactoryGirl.create(:user_bucket, :with_user, :with_drop)
      drop = FactoryGirl.create(
        :drop, bucket_id: bucket.id, user_id: bucket.user.id)
      drop2 = FactoryGirl.create(
        :drop, bucket_id: bucket.id, user_id: bucket.user.id)
      drop3 = FactoryGirl.create(
        :drop, :with_user, bucket_id: bucket.id)
      drop3 = DropActions.new(
        drop: drop3, 
        param: { drop: { media_key: drop.media_key } }
      ).create!
      drop4 = FactoryGirl.create(
        :drop, bucket_id: bucket.id, user_id: bucket.user.id)
      drop5 = FactoryGirl.create(
        :drop, :with_user, bucket_id: bucket.id)
      drop5 = DropActions.new(
        drop: drop5, 
        param: { drop: { media_key: drop.media_key } }
      ).create!

      expect(drop3.parent_id).to eql(drop2.id)
      expect(drop5.parent_id).to eql(drop4.id)
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

end
