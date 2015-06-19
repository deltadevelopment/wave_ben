class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :temperature
      t.references :user, null: false
      t.references :drop, null: false
      t.references :bucket, null: false
      t.timestamps null: false
    end
  end
end
