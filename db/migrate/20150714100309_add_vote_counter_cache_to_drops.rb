class AddVoteCounterCacheToDrops < ActiveRecord::Migration
  def change
    add_column :drops, :vote_zero_count, :integer, default: 0
    add_column :drops, :vote_one_count, :integer, default: 0
  end
end
