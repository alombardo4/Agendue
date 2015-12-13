class AddMutedProjectsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :muted_projects, :string
  end
end
