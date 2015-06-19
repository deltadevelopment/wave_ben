class AddPolymorphismToTags < ActiveRecord::Migration
  def change
    change_table(:tags) do |t|
      t.remove :taggee_id
      t.remove :tag_type_id
      t.remove :drop_id
      t.remove :bucket_id

      t.belongs_to :taggee, polymorphic: true

      t.belongs_to :taggable, polymorphic: true
      
      t.index :taggable_id
      t.index :taggee_id
    end
  end
end
