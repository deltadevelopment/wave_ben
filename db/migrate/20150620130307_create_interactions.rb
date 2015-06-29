class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.references :user
      t.references :topic, polymorphic: true
      t.string :action
      t.timestamps null: false
    end
  end
end
