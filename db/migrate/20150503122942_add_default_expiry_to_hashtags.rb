class AddDefaultExpiryToHashtags < ActiveRecord::Migration
  def change
    change_column :hashtags, :expires, :integer, default: 7
  end
end
