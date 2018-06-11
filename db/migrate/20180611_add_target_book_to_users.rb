class AddTargetBookToUsers < ActiveRecord::Migration
  def change
    add_column :users, :target_book, :string
    add_column :users, :target_book_unit, :string
    add_column :users, :target_book_qty, :integer
  end

end