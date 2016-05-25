class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :name
    	t.string :city
      	t.string :state
      	t.string :address
      	t.string :country
      	t.string :phone_number

      t.timestamps null: false
    end
  end
end
