class RemovePrivateProfileFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :private_profile
  end
end
