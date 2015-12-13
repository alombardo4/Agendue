class FixPersonalTasks < ActiveRecord::Migration
  def change
    for task in PersonalTask.all
      if task.complete != true
        task.complete = false
        task.save!
      end
    end
  end
end
