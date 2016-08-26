class CreateNewRecommendations < ActiveRecord::Migration
  def change
    create_table :new_recommendations do |t|
      t.string :user_email
      t.string :mentor_email
      t.decimal :score
      t.jsonb :preferences, null: false, default: '{}'

      t.timestamps
    end

    add_index :new_recommendations, :user_email
    add_index :new_recommendations, :mentor_email
  end
end
