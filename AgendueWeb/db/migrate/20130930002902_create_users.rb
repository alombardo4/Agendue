class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :userid
      t.string :projectids

      t.timestamps
    end
  end
end
