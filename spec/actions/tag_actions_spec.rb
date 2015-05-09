require 'rails_helper'

describe TagActions do

  describe "#create!" do
  
    it "updates expires to 7 for existing hashtags" do
      tag = FactoryGirl.build(:tag_hashtag, :with_saved_hashtag)
      tag.taggee.update_attributes(expires: 5)

      tag = TagActions.new(
        tag: tag,
        param: { tag_string: "##{tag.taggee.tag_string}"}
      ).create!

      expect(tag.taggee.expires).to eq(7)
    end

  end

end
