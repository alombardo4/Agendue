class CreatePremiumUsers < ActiveRecord::Migration
  def change
    create_table :premium_users do |t|
      t.string :name
      t.boolean :admin_init

      t.timestamps
    end
  end
end
