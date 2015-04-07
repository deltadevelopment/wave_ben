class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :auth_token
      t.references :user, index: true
      t.string :device_id
      t.integer :device_type
      t.timestamps null: false
    end
  end
end
