class AddLabelToPersonalTasks < ActiveRecord::Migration
  def change
    add_column :personal_tasks, :label, :integer
  end
end
