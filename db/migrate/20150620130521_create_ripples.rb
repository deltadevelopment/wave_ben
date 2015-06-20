class CreateRipples < ActiveRecord::Migration
  def change
    create_table :ripples do |t|
      t.references :interaction
      t.references :user
      t.datetime :seen_at
      t.timestamps null: false
    end
  end
end
