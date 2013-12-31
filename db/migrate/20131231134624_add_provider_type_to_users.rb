class AddProviderTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider_type, :string
  end
end
