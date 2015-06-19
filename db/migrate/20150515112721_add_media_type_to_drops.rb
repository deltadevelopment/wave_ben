class AddMediaTypeToDrops < ActiveRecord::Migration
  def change
    add_column :drops, :media_type, :integer, null: false, default: 0
  end
end
