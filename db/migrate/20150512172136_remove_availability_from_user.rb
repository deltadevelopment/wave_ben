class RemoveAvailabilityFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :availability, :integer
  end
end
