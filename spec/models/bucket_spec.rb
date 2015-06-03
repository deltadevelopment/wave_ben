require 'rails_helper'

describe Bucket do

  it { should belong_to(:user) }
  it { should have_many(:tags).dependent(:destroy) }
  it { should have_many(:drops).dependent(:destroy ) }
  it { should have_many(:votes) }
  it { should have_many(:watchers).dependent(:destroy) }

  describe "title format" do

    let(:shared_bucket) { FactoryGirl.build(:shared_bucket) }
    
    it "allows special characters" do
      shared_bucket.title = "!@#\$("
      shared_bucket.bucket_type.to_s
      expect(shared_bucket).to be_valid
    end

    it "should be at least one character" do
      shared_bucket.title = ""
      expect(shared_bucket).to_not be_valid
    end

  end

  describe "user buckets" do
    let(:user_bucket) { FactoryGirl.create(:user_bucket) }

    it "cant set title for user buckets" do
      user_bucket.title = "abc"
      expect(user_bucket).to_not be_valid
    end

  end

end
