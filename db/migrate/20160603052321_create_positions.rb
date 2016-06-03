class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :company_name
      t.integer :company_id
      t.string :title
      t.boolean :is_current
      t.string :location_name
      t.string :country
      t.integer :start_month
      t.integer :start_year
      t.integer :end_month
      t.integer :end_year

      t.timestamps null: false
    end
  end
end
