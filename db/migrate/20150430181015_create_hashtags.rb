class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :tag_string
      t.integer :count
      t.integer :expires
      t.timestamps null: false
    end
  end
end
