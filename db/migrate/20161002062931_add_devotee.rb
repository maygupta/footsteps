class AddDevotee < ActiveRecord::Migration
  def change
    create_table :devotees do |t|
      t.string :name
      t.date :birthday
      t.string :email
      t.string :address
      t.integer :rounds

      t.timestamps null: false
    end
  end
end
