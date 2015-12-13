class AddSharesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :shares, :string
  end
end
