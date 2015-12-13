class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user
      t.string :subject
      t.text :content

      t.timestamps
    end
  end
end
