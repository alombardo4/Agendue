class AddWikiToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :wiki, :text
  end
end
