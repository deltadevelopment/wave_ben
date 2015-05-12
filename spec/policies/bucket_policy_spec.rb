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

end
