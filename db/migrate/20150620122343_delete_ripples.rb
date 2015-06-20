class DeleteRipples < ActiveRecord::Migration
  def change
    drop_table :ripples
  end
end
