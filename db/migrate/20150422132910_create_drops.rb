class CreateDrops < ActiveRecord::Migration
  def change
    create_table :drops do |t|
      t.string :media_key
      t.string :caption
      t.references :parent
      t.references :bucket
      t.references :user

      t.integer :parent_id, :null => true, :index => true
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true      

      t.timestamps null: false
    end
  end
end
