class AddSnsEndpointArnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sns_endpoint_arn, :string
  end
end
