class CreateBuckets < ActiveRecord::Migration
  def change
    create_table :buckets do |t|
      t.integer :bucket_type, :default => 0
      t.integer :temperature, :default => 50

      t.integer :visibility, :default => 0
      t.boolean :locked, :default => true 

      t.references :user

      t.string :title
      t.string :description

      t.date :when 

      t.timestamps null: false
    end
  end
end
