class AddCounterCaches < ActiveRecord::Migration
  def change
    add_column :users, :subscribers_count, :integer, null: false, default: 0
    add_column :users, :subscriptions_count, :integer, null: false, default: 0
    add_column :buckets, :drops_count, :integer, null: false, default: 0
    add_column :hashtags, :tags_count, :integer, null: false, default: 1
    add_column :drops, :likes_count, :integer, null: false, default: 0
  end
end
