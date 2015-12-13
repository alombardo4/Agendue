class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message
      t.string :device_token
      t.string :notification_os
      t.integer :project_id

      t.timestamps
    end
  end
end
