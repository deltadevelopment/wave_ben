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

      end
    end
  end
end
