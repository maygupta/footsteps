class AddUDIDTable < ActiveRecord::Migration
  def change
    create_table :udids do |t|
      t.string :name
      t.string :description
        
      t.timestamps null: false
    end

  end
end
