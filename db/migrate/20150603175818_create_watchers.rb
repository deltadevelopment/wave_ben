class CreateWatchers < ActiveRecord::Migration
  def change
    create_table :watchers do |t|
      t.references :user, null: false
      t.belongs_to :watchable, polymorphic: true, null: false
      t.timestamps null: false
    end
  end
end
