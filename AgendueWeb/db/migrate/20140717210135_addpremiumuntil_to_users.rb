class AddpremiumuntilToUsers < ActiveRecord::Migration
  def change
    add_column :users, :premiumuntil, :DATETIME
  end
end
