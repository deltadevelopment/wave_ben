require 'rails_helper'

describe BucketActions do

  describe "#create!" do
    let(:bucket) { FactoryGirl.build(:shared_bucket, :with_user) }
    let(:param) { 
      { drop: {
          media_key: 'A'*64,
          media_type: 0 } }
    }

    it "saves the bucket" do
      expect{
        BucketActions.new(bucket: bucket, param: param).create!
      }.to change(Bucket, :count).by(1) 
    end

    it "saves the drop" do
      expect{
        BucketActions.new(bucket: bucket, param: param).create!
      }.to change(Drop, :count).by(1) 
    end

    it "adds a watcher" do
      expect{
        BucketActions.new(bucket: bucket, param: param).create!
      # The watcher count is changed by 2 because DropActions 
      # also adds a watcher for the Drop
      }.to change(Watcher, :count).by(2) 
    end

    it "saves an interaction" do
      expect{
        BucketActions.new(bucket: bucket, param: param).create!
      # The interaction count is changed by 2 because DropActions 
      # also adds a watcher for the Drop
      }.to change(Interaction, :count).by(2)
    end

  end

end
