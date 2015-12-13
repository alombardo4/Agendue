class AddSubjectToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :subject, :string
  end
end
