class AddProjectidToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :projectid, :integer
  end
end
