class AddAllsharesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :allshares, :string
  end
end
