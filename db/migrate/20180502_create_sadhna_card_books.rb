class CreateSadhnaCardBooks < ActiveRecord::Migration
  def change
    create_table :sadhna_card_books do |t|
    	t.string :book
    	t.integer :qty
      	t.string :unit
      	t.integer :sadhna_card_id
      	
      	t.timestamps null: false
    end
  end
end
