class AddCategoryToNewRecommendation < ActiveRecord::Migration
  def change
    add_column :new_recommendations, :category, :string
  end
end
