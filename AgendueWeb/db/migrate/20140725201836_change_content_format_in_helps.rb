class ChangeContentFormatInHelps < ActiveRecord::Migration
	def change
		change_column :helps, :content, :text
	end
end
