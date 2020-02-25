class AddSlokaTable < ActiveRecord::Migration
  def change
    create_table :slokas do |t|
      t.string :scripture
      t.string :english
      t.string :sanskrit
      t.string :purport
      t.string :word_by_word
        
      t.timestamps null: false
    end

  end
end
