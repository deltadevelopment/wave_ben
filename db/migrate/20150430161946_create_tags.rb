class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :drop
      t.references :bucket
      t.references :taggee
      t.references :tag_type
      t.timestamps null: false
    end
  end
end
