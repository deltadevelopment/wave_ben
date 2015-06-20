require 'rails_helper'

describe Drop do

  it { should belong_to(:bucket) }
  it { should belong_to(:user) }
  it { should have_many(:tags).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:watchers).dependent(:destroy) }
  it { should have_many(:interactions).dependent(:destroy) }

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

end
