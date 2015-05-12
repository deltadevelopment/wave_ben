require 'rails_helper'

describe TagActions do

  describe "#create!" do
  
    describe "updates existing hashtags" do

        let!(:tag) { FactoryGirl.build(:tag_hashtag, :with_saved_hashtag) }

      it "updates expires to 7 for existing hashtags" do
        tag.taggee.update_attributes(expires: 5)

        TagActions.new(
          tag: tag,
          param: { tag_string: "##{tag.taggee.tag_string}"}
        ).create!

        expect(tag.taggee.expires).to eq(7)
      end

      it "increases count by 1 for existing hashtags"do
        TagActions.new(
          tag: tag,
          param: { tag_string: "##{tag.taggee.tag_string}"}
        ).create!

        expect(tag.taggee.tags_count).to eq(2)
      end

    end

    it "creates new captions for drops" do
        drop = FactoryGirl.build(:drop, :with_user_bucket)
        FactoryGirl.create(:user, :username => "miri")

        expect{
          drop = DropActions.new(
            drop: drop,
            param: { caption: "hello #oslo @miri come to #berlin" }
          ).create!
        }.to change(Tag, :count).by(3)
    end

  end

end
