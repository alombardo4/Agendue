class AddPremiumoverrideToUsers < ActiveRecord::Migration
  def change
    add_column :users, :premiumoverride, :boolean
  end
end
