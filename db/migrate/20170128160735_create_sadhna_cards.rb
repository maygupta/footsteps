class CreateSadhnaCards < ActiveRecord::Migration
  def change
    create_table :sadhna_cards do |t|
      t.date :date
      t.integer :japa_rounds
      t.string :reading
      t.string :chad
      t.time :wakeup
      t.time :rest_time
      t.string :hearing
      
      t.timestamps
    end
  end
end
