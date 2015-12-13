class AddStripeidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripeid, :string
  end
end
