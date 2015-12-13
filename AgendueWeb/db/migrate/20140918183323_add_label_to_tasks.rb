class AddLabelToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :label, :integer
  end
end
