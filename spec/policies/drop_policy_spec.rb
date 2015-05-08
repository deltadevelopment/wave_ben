require 'rails_helper'

describe DropPolicy do

  subject { described_class }

  permissions :create? do

    context "bucket is visible to everyone" do

      context "bucket is unlocked" do
        let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :everyone, :with_taggee, :unlocked) }
        let(:user) { FactoryGirl.create(:user) }
    
        it "allows the owner to add new drops" do
          expect(subject).to permit(bucket.user, Drop.new(bucket: bucket))
        end

        it "allows tagged users to add new drops" do
          expect(subject).to permit(bucket.tags[0].taggee, Drop.new(bucket: bucket))
        end

        it "allows untagged users to add new drops" do
          expect(subject).to permit(user, Drop.new(bucket: bucket))
        end

      end

      context "bucket is locked" do
        let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :everyone, :with_taggee, :locked) }

        it "allows the owner to add new drops" do
          expect(subject).to permit(bucket.user, Drop.new(bucket: bucket))
        end

        it "allows tagged users to add new drops" do
          expect(subject).to permit(bucket.tags[0].taggee, Drop.new(bucket: bucket))
        end

        it "does not allow untagged users to add new drops" do
          expect(subject).to_not permit(User.new, Drop.new(bucket: bucket))
        end

      end

      context "bucket is visible to tagged users" do
 
        context "bucket is unlocked" do
          let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :taggees, :with_taggee, :unlocked) }

          it "allows the owner to add new drops" do
            expect(subject).to permit(bucket.user, Drop.new(bucket: bucket))
          end

          it "allows tagged users to add new drops" do
            expect(subject).to permit(bucket.tags[0].taggee, Drop.new(bucket: bucket))
          end

          it "does not allow untagged users to add new drops" do
            expect(subject).to_not permit(User.new, Drop.new(bucket: bucket))
          end

        end

        context "bucket is locked" do
          let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :taggees, :with_taggee, :locked) }

          it "allows the owner to add new drops" do
            expect(subject).to permit(bucket.user, Drop.new(bucket: bucket))
          end

          it "does not allow tagged users to add new drops" do
            expect(subject).to_not permit(bucket.tags[0].taggee, Drop.new(bucket: bucket))
          end

          it "does not allow untagged users to add new drops" do
            expect(subject).to_not permit(User.new, Drop.new(bucket: bucket))
          end

        end

      end

    end

  end

  permissions :destroy? do

    let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :taggees, :with_taggee, :with_drop, :locked) }
    let(:user) { FactoryGirl.create(:user) }

    it "allows the bucket owner to delete the drop" do
      expect(subject).to permit(bucket.user, Drop.new(bucket: bucket))
    end

    it "allows the drop owner to delete the drop" do
      user = User.new
      expect(subject).to permit(user, Drop.new(bucket: bucket, user: user))
    end

    it "does not allow tagged users to delete the drop" do
      expect(subject).to_not permit(bucket.tags[0].taggee, Drop.new(bucket: bucket)) 
    end

    it "does not allow untagged users to delete the drop" do
      expect(subject).to_not permit(user, Drop.new(bucket: bucket)) 
    end
  end

end
