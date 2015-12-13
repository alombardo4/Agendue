class AddShareCalendarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :share_calendar, :boolean
  end
end
