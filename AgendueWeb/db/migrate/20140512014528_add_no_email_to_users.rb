class AddNoEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :noemail, :boolean
  end
end
