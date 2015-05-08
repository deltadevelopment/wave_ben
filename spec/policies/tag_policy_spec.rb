require 'rails_helper'

describe TagPolicy do
    
  subject { described_class }

  permissions :create? do
    
    context "bucket is visible to everyone" do

      context "bucket is unlocked" do
        let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :everyone, :with_taggee, :unlocked) }
        let(:user) { FactoryGirl.create(:user) }
    
        it "allows the owner to create new tags" do
          expect(subject).to permit(bucket.user, Tag.new(taggable: bucket))
        end

        it "allows tagged users to create new tags" do
          expect(subject).to permit(bucket.tags[0].taggee, Tag.new(taggable: bucket))
        end

        it "allows untagged users to create new tags" do
          expect(subject).to permit(user, Tag.new(taggable: bucket))
        end

      end

      context "bucket is locked" do
        let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :everyone, :with_taggee, :locked) }

        it "allows the owner to create new tags" do
          expect(subject).to permit(bucket.user, Tag.new(taggable: bucket))
        end

        it "allows tagged users to create new tags" do
          expect(subject).to permit(bucket.tags[0].taggee, Tag.new(taggable: bucket))
        end

        it "does not allow untagged users to create new tags" do
          expect(subject).to_not permit(User.new, Tag.new(taggable: bucket))
        end

      end

      context "bucket is visible to tagged users" do
 
        context "bucket is unlocked" do
          let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :taggees, :with_taggee, :unlocked) }

          it "allows the owner to create new tags" do
            expect(subject).to permit(bucket.user, Tag.new(taggable: bucket))
          end

          it "allows tagged users to create new tags" do
            expect(subject).to permit(bucket.tags[0].taggee, Tag.new(taggable: bucket))
          end

          it "does not allow untagged users to create new tags" do
            expect(subject).to_not permit(User.new, Tag.new(taggable: bucket))
          end

        end

        context "bucket is locked" do
          let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :taggees, :with_taggee, :locked) }

          it "allows the owner to create new tags" do
            expect(subject).to permit(bucket.user, Tag.new(taggable: bucket))
          end

          it "does not allow tagged users to create new tags" do
            expect(subject).to_not permit(bucket.tags[0].taggee, Tag.new(taggable: bucket))
          end

          it "does not allow untagged users to create new tags" do
            expect(subject).to_not permit(User.new, Tag.new(taggable: bucket))
          end

        end

      end

    end

  end

  permissions :destroy? do

    let(:bucket) { FactoryGirl.create(:shared_bucket, :with_user, :taggees, :with_taggee, :locked) }
    let(:user) { FactoryGirl.create(:user) }

    it "allows the owner to delete tags" do
      expect(subject).to permit(bucket.user, Tag.new(taggable: bucket)) 
    end

    it "does not allow tagged users to delete tags" do
      expect(subject).to_not permit(bucket.tags[0].taggee, Tag.new(taggable: bucket)) 
    end

    it "does not allow untagged users to delete tags" do
      expect(subject).to_not permit(user, Tag.new(taggable: bucket)) 
    end
  end

end
