class RemoveAwesomeNestedSetFromDrops < ActiveRecord::Migration
  def change
    change_table :drops do |t|
      t.remove :parent_id
      t.remove :lft
      t.remove :rgt
    end
  end
end
