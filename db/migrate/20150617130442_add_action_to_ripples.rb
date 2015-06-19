class AddActionToRipples < ActiveRecord::Migration
  def change
    add_column :ripples, :action, :string
  end
end
