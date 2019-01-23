class AddColumnsDeleteComments < ActiveRecord::Migration[5.2]
  def change
		add_column :users, :birthday, :date
		add_column :users, :email, :string
		drop_table :comments
		add_column :posts, :comments, :text
		add_column :posts, :modified_date, :datetime
  end
end
