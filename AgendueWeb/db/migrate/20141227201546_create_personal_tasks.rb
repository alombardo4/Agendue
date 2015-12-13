class CreatePersonalTasks < ActiveRecord::Migration
  def change
    create_table :personal_tasks do |t|
      t.string :title
      t.text :description
      t.boolean :complete
      t.integer :userid
      t.datetime :duedate

      t.timestamps
    end
  end
end
