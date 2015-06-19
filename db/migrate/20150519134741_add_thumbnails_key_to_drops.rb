class AddThumbnailsKeyToDrops < ActiveRecord::Migration
  def change
    add_column :drops, :thumbnail_key, :string
  end
end
