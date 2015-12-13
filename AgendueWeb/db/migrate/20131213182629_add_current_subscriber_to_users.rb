class AddCurrentSubscriberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :currentSubscriber, :boolean
  end
end
