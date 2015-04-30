require 'rails_helper'

describe Drop do

  let(:bucket) { FactoryGirl.create(:user_bucket, :with_drop) }
  let(:drop) { FactoryGirl.build(:drop) }

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

end
