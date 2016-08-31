class CreateDarshans < ActiveRecord::Migration
  def change
    create_table :darshans do |t|
      t.string :url
      t.string :description
      t.timestamps null: false
    end
  end
end
