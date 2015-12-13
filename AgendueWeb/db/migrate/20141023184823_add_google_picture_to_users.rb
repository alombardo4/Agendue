class AddGooglePictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_picture, :string
  end
end
