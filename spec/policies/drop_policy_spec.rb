require 'rails_helper'

describe DropPolicy do

  subject { described_class }

  permissions :create? do
    
    context "shared bucket" do
      let(:bucket) do
        FactoryGirl.create(:shared_bucket, :taggees, :with_taggee, :with_user) 
      end

      it "allows the owner to add drops" do
        expect(subject).to permit(bucket.user, Drop.new(bucket: bucket))
      end
      
      context "bucket is visible to everyone" do
        let(:bucket) { FactoryGirl.create(:shared_bucket, :everyone) }

        it "allows anyone to add drops" do
          expect(subject).to permit(User.new, Drop.new(bucket: bucket))
        end
      end      

      context "bucket is visible to taggees" do
        let(:bucket) do
          FactoryGirl.create(:shared_bucket, :everyone, :with_taggee)
        end

        it "allows tagged users to add drops" do
          expect(subject).to permit(bucket.tags[0], Drop.new(bucket: bucket))
        end
      end

    end 

    context "user bucket" do
      let(:bucket) do
        FactoryGirl.create(:user_bucket, :with_user)
      end

      it "allows the owner to add drops" do
        expect(subject).to permit(bucket.user, Drop.new(bucket: bucket))
      end

      it "does not allow anyone to add a drop" do
        expect(subject).to_not permit(User.new, Drop.new(bucket: bucket))
      end

    end

  end

  permissions :destroy? do
    context "shared bucket" do
      let(:bucket) do
        FactoryGirl.create(:shared_bucket, :taggees, :with_taggee, :with_user) 
      end
      let(:drop) do
        FactoryGirl.create(:drop, :with_shared_bucket)
      end
      let(:user) { FactoryGirl.create(:user) }

      it "allows the bucket owner to delete drops" do
        expect(subject).to permit(bucket.user, Drop.new(bucket: bucket))
      end

      it "allows the drop owner to delete the drop" do
        expect(subject).to permit(drop.user, drop)
      end

      it "does not allow anyone else to delete the drop" do
        expect(subject).to_not permit(user, Drop.new(bucket: bucket))
      end

    end 

    context "user bucket" do
      let(:bucket) do
        FactoryGirl.create(:user_bucket, :with_user)
      end
      let(:user) { FactoryGirl.create(:user) }

      it "allows the owner to delete drops" do
        expect(subject).to permit(bucket.user, Drop.new(bucket: bucket))
      end

      it "does not allow anyone to delete a drop" do
        expect(subject).to_not permit(user, Drop.new(bucket: bucket))
      end

    end

  end

  permissions :vote? do

    context "bucket visible to taggees" do

      let(:bucket) { 
        FactoryGirl.create(
          :shared_bucket, :taggees, :with_user, :with_taggee
        ) 
      }
      
      it "allows the owner to vote" do
        expect(subject).to permit(bucket.user, Drop.new(bucket: bucket))
      end 

      it "allows taggees to vote on a tagged bucket" do
        expect(subject).to permit(bucket.tags[0].taggee, Drop.new(bucket: bucket))
      end

      it "does not allow anyone to vote on a tagged bucket" do
        expect(subject).to_not permit(User.new, Drop.new(bucket: bucket))
      end

  end

  let(:bucket) { FactoryGirl.create(:shared_bucket, :everyone) }

  it "allows anyone to comment on a bucket visible to everyone" do
    expect(subject).to permit(User.new, Drop.new(bucket: bucket))
  end

  end

end
