class ChangeNotificationsToRipples < ActiveRecord::Migration
  def change
    rename_table :notifications, :ripples
  end
end
