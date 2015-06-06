class AddPushableToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :pushable, :boolean, default: false
  end
end
