class RenameTemperature < ActiveRecord::Migration
  def change
    rename_column :votes, :temperature, :vote
  end
end
