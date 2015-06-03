class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message
      t.references :user
      t.references :triggee
      t.belongs_to :trigger, polymorphic: true
      t.datetime :seen_at
      t.timestamps null: false
    end
  end
end
