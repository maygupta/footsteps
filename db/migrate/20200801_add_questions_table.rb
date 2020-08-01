class AddQuestionsTable < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.datetime :ask_time
      t.string :name
      t.string :type
      t.text :value
      t.string :verse
      t.text :answer
      t.text :refined_answer
      t.boolean :read
      t.boolean :research

      t.timestamps null: false
    end

  end
end
