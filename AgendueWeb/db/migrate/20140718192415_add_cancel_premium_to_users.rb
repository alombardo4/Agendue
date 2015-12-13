class AddCancelPremiumToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cancelPremium, :boolean
  end
end
