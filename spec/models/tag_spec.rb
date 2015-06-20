require 'rails_helper'

describe Tag do

  it { should belong_to(:taggee) }
  it { should belong_to(:taggable) }
  it { should have_many(:interactions).dependent(:destroy) }

  describe "tag_string format" do

    context "when using a hashtag" do

      let(:tag) { FactoryGirl.build(:tag_hashtag) }

      it "tests the tests" do
        expect(tag).to be_valid
      end
      
      it "can contain letters and numbers" do
        tag.tag_string = "#juice123"
        expect(tag).to be_valid
      end
      
      it "can't start with numbers" do
        tag.tag_string = "#123"
        expect(tag).to_not be_valid
      end

      it "can contain underscores" do
        tag.tag_string = "#juice_123"
        expect(tag).to be_valid
      end

      it "can't start with underscores" do
        tag.tag_string = "#_juice_123"
        expect(tag).to_not be_valid
      end

    end

    context "when using a usertag" do
      let(:tag) { FactoryGirl.build(:usertag) }

      it "tests the tests" do
        expect(tag).to be_valid
      end
      
      it "can contain letters and numbers" do
        tag.tag_string = "@juice123"
        expect(tag).to be_valid
      end
      
      it "can start with numbers" do
        tag.tag_string = "@123abc"
        expect(tag).to be_valid
      end

      it "can consist of just numbers" do
        tag.tag_string = "@123"
        expect(tag).to be_valid
      end

      it "can contain underscores" do
        tag.tag_string = "@123_abc"
        expect(tag).to be_valid
      end

      it "can start with an underscore" do
        tag.tag_string = "@_"
        expect(tag).to be_valid
      end

    end

    context "when tagging a bucket" do
      let(:tag) { FactoryGirl.build(:usertag) }
      
      it "can not be a user bucket" do
        bucket = FactoryGirl.create(:user_bucket)
        tag.taggable = bucket
        expect(tag).to_not be_valid
      end

      it "can be a shared bucket" do
        bucket = FactoryGirl.create(:shared_bucket)
        tag.taggable = bucket
        expect(tag).to be_valid
      end


    end

  end


end
