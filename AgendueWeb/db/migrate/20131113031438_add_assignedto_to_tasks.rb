class AddAssignedtoToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :assignedto, :string
  end
end
