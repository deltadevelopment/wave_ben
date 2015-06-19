class AddProfilePictureKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :profile_picture_key, :string
  end
end
