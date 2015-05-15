class ChangesFromProductRedesign < ActiveRecord::Migration
  def change
    # Drops
    remove_column :drops, :likes_count, :integer
    add_column :drops, :temperature, :integer, null: false, default: 25

    # Buckets
    remove_column :buckets, :temperature, :integer
    remove_column :buckets, :description, :integer
    remove_column :buckets, :when_datetime, :datetime
    remove_column :buckets, :locked, :boolean

  end
end
