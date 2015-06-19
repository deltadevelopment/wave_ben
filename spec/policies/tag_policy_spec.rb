require 'rails_helper'

describe TagPolicy do
    
  subject { described_class }

  permissions :create? do
    context "shared bucket" do
      let(:bucket) do
        FactoryGirl.create(:shared_bucket, :taggees, :with_taggee, :with_user) 
      end

      it "allows the owner to add tags" do
        expect(subject).to permit(bucket.user, Tag.new(taggable: bucket))
      end

      it "does not allow everyone to add a tag" do
        expect(subject).to_not permit(User.new, Tag.new(taggable: bucket))
      end

    end 

    context "user bucket" do
      let(:bucket) do
        FactoryGirl.create(:user_bucket, :with_user)
      end

      it "allows the owner to add tags" do
        expect(subject).to permit(bucket.user, Tag.new(taggable: bucket))
      end

      it "does not allow anyone to add a tag" do
        expect(subject).to_not permit(User.new, Tag.new(taggable: bucket))
      end

    end
  end

  permissions :destroy? do
    context "shared bucket" do
      let(:bucket) do
        FactoryGirl.create(:shared_bucket, :taggees, :with_taggee, :with_user) 
      end

      it "allows the owner to destroy tags" do
        expect(subject).to permit(bucket.user, Tag.new(taggable: bucket))
      end

      it "does not allow everyone to destroy a tag" do
        expect(subject).to_not permit(User.new, Tag.new(taggable: bucket))
      end

    end 

    context "user bucket" do
      let(:bucket) do
        FactoryGirl.create(:user_bucket, :with_user)
      end

      it "allows the owner to destroy tags" do
        expect(subject).to permit(bucket.user, Tag.new(taggable: bucket))
      end

      it "does not allow others to destroy a tag" do
        expect(subject).to_not permit(User.new, Tag.new(taggable: bucket))
      end

    end


  end

end
