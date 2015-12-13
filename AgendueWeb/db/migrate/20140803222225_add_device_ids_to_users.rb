class AddDeviceIdsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deviceids, :string
  end
end
