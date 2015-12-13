class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.date :duedate
      t.date :personalduedate
      t.boolean :complete
      t.integer :taskid
      t.integer :projectid

      t.timestamps
    end
  end
end
