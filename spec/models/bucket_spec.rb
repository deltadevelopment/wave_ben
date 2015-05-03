require 'rails_helper'

describe Bucket do

  it { should belong_to(:user) }
  it { should have_many(:tags).dependent(:destroy) }
  it { should have_many(:drops).dependent(:destroy ) }

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

  describe "description format" do
    
    let(:shared_bucket) { FactoryGirl.build(:shared_bucket) }

    it "should be less than 250 characters" do
      shared_bucket.description = 'A'*251
      expect(shared_bucket).to_not be_valid
    end

    it "can be blank" do
      shared_bucket.description = ""
      expect(shared_bucket).to be_valid
    end

  end

end
