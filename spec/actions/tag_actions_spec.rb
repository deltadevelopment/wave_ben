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

    describe "when adding a usertag" do
      let!(:tag) { FactoryGirl.build(:usertag) }
      
      it "sets the buckets visibility to taggees" do

        TagActions.new(
          tag: tag,
          param: { tag_string: "@#{tag.taggee.username}"}
        ).create!

        expect(tag.taggable.reload.taggees?).to eql(true) 
      end

      it "saves an interaction" do
        expect{
          TagActions.new(
            tag: tag,
            param: { tag_string: "@#{tag.taggee.username}"}
          ).create!
        }.to change(Interaction, :count).by(1)
      end

      it "deletes the current watchers" do
        FactoryGirl.create(:watcher, watchable: tag.taggable)
        TagActions.new(
          tag: tag,
          param: { tag_string: "@#{tag.taggee.username}"}
        ).create!
        # 2 because the owner and the taggee now watches it too
        expect(tag.taggable.watchers.count).to eql(2)
      end

      it "haves the user and the owner Watch the bucket" do
        expect{
          TagActions.new(
            tag: tag,
            param: { tag_string: "@#{tag.taggee.username}"}
          ).create!
        }.to change(Watcher, :count).by(2)
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

  describe "#destroy" do
    
    context "destroying a user tag" do
      let(:bucket) do
        FactoryGirl.create(:shared_bucket, :taggees, :with_taggee, :with_drop)
      end
      let(:user) { FactoryGirl.create(:user) }

      it "destroying the last usertag returns the bucket 
          visibility to everyone" do
        TagActions.new(
          tag: bucket.tags[0],
          param: { tag_string: "@#{bucket.tags[0].taggee.username}" }
        ).destroy!
        expect(bucket.reload.everyone?).to be(true) 
      end

      it "destroying a single usertag does not change visibility" do
        tag_string = "@#{user.username}"
        TagActions.new(
          tag: Tag.new(taggee: user, taggable: bucket, tag_string: tag_string),
          param: { tag_string: tag_string } 
        ).create!
        TagActions.new(
          tag: bucket.tags[0],
          param: { tag_string: "@#{bucket.tags[0].taggee.username}" }
        ).destroy!
        expect(bucket.reload.taggees?).to be(true) 
      end
      
      it "deletes the users drops from the bucket" do
        user = bucket.drops[0].user
        tag_string = "@#{user.username}"
        tag = Tag.new(taggee: user, taggable: bucket, tag_string: tag_string)
        TagActions.new(
          tag: tag,
          param: { tag_string: tag_string } 
        ).create!

        expect {
          TagActions.new(
            tag: tag,
            param: { tag_string: "@#{user.username}" }
          ).destroy!
        }.to change(Drop, :count).by(-1)

      end

    end
  end

end
