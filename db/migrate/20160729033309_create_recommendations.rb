class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :user_id
      t.jsonb :preferences, null: false, default: '{}'

      t.timestamps
    end

    add_index :recommendations, :user_id
  end
end
