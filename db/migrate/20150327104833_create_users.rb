class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string 'username'
      t.string 'email' 
      t.integer 'phone_number'
      t.string 'display_name'
      t.integer 'availability', default: 0
      t.string "password_hash"
      t.string "password_salt"
      t.boolean "private_profile", default: false
      t.timestamps null: false
    end
  end
end
