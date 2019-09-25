class AddGroupTable < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
        
      t.timestamps null: false
    end

    add_column :description, :section, :string
  end
end
