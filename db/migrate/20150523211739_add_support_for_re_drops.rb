class AddSupportForReDrops < ActiveRecord::Migration
  def change
    add_column :drops, :drop_id, :integer
  end
end
