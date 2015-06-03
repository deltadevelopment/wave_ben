require 'rails_helper'

describe BucketPolicy do

  subject { described_class }

  permissions :show? do

  context "bucket is only visible to tagged users" do
    let(:bucket) { FactoryGirl.create(:shared_bucket, :taggees, :with_user, :with_taggee) }
      it "allows the owner to view the bucket" do
        expect(subject).to permit(bucket.user, bucket)
      end

      it "allows tagged users to view the bucket" do
        expect(subject).to permit(bucket.tags[0].taggee, bucket)
      end

      it "does not allow untagged users to view the bucket" do
        expect(subject).to_not permit(User.new, bucket)
      end
  end

  context "bucket is only visible to everyone" do
    let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :with_taggee) }

      it "allows the owner to view the bucket" do
        expect(subject).to permit(bucket.user, bucket)
      end

      it "allows tagged users to view the bucket" do
        expect(subject).to permit(bucket.tags[0].taggee, bucket)
      end

      it "does allows untagged users to view the bucket" do
        expect(subject).to permit(User.new, bucket)
      end
  end

  end

  permissions :create? do
    
    it "allows logged in users to create new buckets" do
      expect(subject).to permit(User.new, Bucket.new)
    end

  end 

  permissions :update? do
    let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :with_taggee) }

    it "allows the owner to update the bucket" do
      expect(subject).to permit(bucket.user, bucket)
    end

    it "does not allow taggees to update the bucket" do
      expect(subject).to_not permit(bucket.tags[0].taggee, bucket)
    end

    it "does not allow random users to update the bucket" do
      expect(subject).to_not permit(User.new, bucket)
    end

  end

  permissions :destroy? do
    let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :with_taggee) }

    it "allows the owner to destroy the bucket" do
      expect(subject).to permit(bucket.user, bucket)
    end

    it "does not allow taggees to destroy the bucket" do
      expect(subject).to_not permit(bucket.tags[0].taggee, bucket)
    end

    it "does not allow random users to destroy the bucket" do
      expect(subject).to_not permit(User.new, bucket)
    end
  end

  permissions :buckets_for_user? do
  
    it "allows the owner to see all buckets"

    it "does not show private buckets unless the requester is tagged"

  end

  permissions :watch? do
    let(:user_bucket) { FactoryGirl.create(:user_bucket, :with_user) }
    let(:private_bucket) { 
      FactoryGirl.create(
        :shared_bucket, 
        :taggees, 
        :with_taggee) 
    }

    it "allows the user to watch public buckets" do
      expect(subject).to permit(User.new, user_bucket)
    end

    it "does not allow users to watch buckets hen can't see" do
      expect(subject).to_not permit(user_bucket.user, private_bucket)
    end

    it "allows users to watch private buckets hen can see" do
      expect(subject).to permit(private_bucket.tags[0], private_bucket)
    end

  end

end
