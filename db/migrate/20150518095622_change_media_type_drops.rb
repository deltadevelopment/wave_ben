class ChangeMediaTypeDrops < ActiveRecord::Migration
  def change
    change_column :drops, :media_type, :integer, null: false
  end
end
