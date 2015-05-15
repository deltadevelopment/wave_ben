class RemoveAwesomeNestedSetFromDrops < ActiveRecord::Migration
  def change
    change_table :drops do |t|
      t.remove :parent_id, :integer
      t.remove :lft, :integer, null: false
      t.remove :rgt, :integer, null: false
    end
  end
end
