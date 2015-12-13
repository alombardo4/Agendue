class AddDateCompleteToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :datecomplete, :DATETIME
  end
end
