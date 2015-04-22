class ChangeWhenInBuckets < ActiveRecord::Migration
  def change
    rename_column :buckets, :when, :when_datetime
  end
end
