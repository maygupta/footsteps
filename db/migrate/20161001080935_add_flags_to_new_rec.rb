class AddFlagsToNewRec < ActiveRecord::Migration
  def change
    add_column :new_recommendations, :is_entrepreneur, :boolean
    add_column :new_recommendations, :is_higher_education, :boolean
  end
end