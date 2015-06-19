require 'rails_helper'

describe WatcherPolicy do

  subject { described_class }

  permissions :unwatch? do
    let(:watcher) { FactoryGirl.create(:bucket_watcher) }

    it "allows the owner to unwatch" do
      expect(subject).to permit(watcher.user, watcher)
    end

    it "does not allow other users to unwatch" do
      expect(subject).to_not permit(User.new, watcher)
    end

  end

end
