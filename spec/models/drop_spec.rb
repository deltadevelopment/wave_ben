require 'rails_helper'

describe Drop do

  it { should belong_to(:bucket) }
  it { should belong_to(:user) }
  it { should have_many(:tags).dependent(:destroy) }

  let(:bucket) { FactoryGirl.create(:user_bucket, :with_drop) }
  let(:drop) { FactoryGirl.build(:drop, :with_user_bucket) }

  describe 'media_key format' do

    it 'tests the tests' do
      expect(drop).to be_valid
      expect(bucket).to be_valid
    end
   
    it 'must be unique' do
      drop.media_key = bucket.drops[0].media_key
      expect(drop).to_not be_valid
    end

    it 'should be less than 120 characters' do
      drop.media_key = 'A'*121
      expect(drop).to_not be_valid
    end

    it 'should be more than 60 characters' do
      drop.media_key = 'A'*59
      expect(drop).to_not be_valid
    end

  end

  describe 'thumbnail_key format' do

    it 'tests the tests' do
      expect(drop).to be_valid
      expect(bucket).to be_valid
    end
   
    it 'must be unique' do
      drop.thumbnail_key = bucket.drops[0].thumbnail_key
      expect(drop).to_not be_valid
    end

    it 'should be less than 120 characters' do
      drop.media_key = 'A'*121
      expect(drop).to_not be_valid
    end

    it 'should be more than 60 characters' do
      drop.media_key = 'A'*59
      expect(drop).to_not be_valid
    end

  end
  
  describe 'media_type format' do
    it 'must be present' do
      drop.media_type = nil
      expect(drop).to_not be_valid
    end 
  end

  describe "counters" do

    
    it "keeps a total count of drops in the bucket" do
      drop = FactoryGirl.create(:drop, :with_user_bucket)
    end

  end

  describe "#generate_download_uri" do
    let(:drop) { FactoryGirl.create(:drop) }

    it "sets the media_url given a thumbnail_key" do
      url = drop.generate_download_uri(media: drop.media_key)
      expect(drop.media_url).to eql(url)
    end

    it "sets the thumbnail_url given a thumbnail_key" do
      url = drop.generate_download_uri(thumbnail: drop.thumbnail_key)
      expect(drop.thumbnail_url).to eql(url)
    end

    it "raises an ArgumentError with no paramenter" do
      expect{
        drop.generate_download_uri
      }.to raise_error(ArgumentError)
    end

  end

end
