require 'rails_helper'

describe WatcherActions do

  describe "#create!" do
    let(:bucket) { FactoryGirl.create(:user_bucket, :with_drop, :with_user) }

    it "creates a new watcher" do
      expect{
        WatcherActions.new(
          watcher: Watcher.new(
            user: bucket.user,
            watchable: bucket.drops[0]
          )
        ).create!
      }.to change(Watcher, :count).by(1)
    end

  end

  describe "#destroy!" do
    let!(:watcher) { FactoryGirl.create(:drop_watcher) }

    it "detroys the watcher" do
      expect{
        WatcherActions.new(watcher: watcher).destroy!
      }.to change(Watcher, :count).by(-1)
    end

  end

end
