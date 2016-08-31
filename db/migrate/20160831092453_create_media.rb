class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :url
      t.string :name
      t.string :author
      t.string :category
      t.string :author_image_url
      t.timestamps null: false
    end
  end
end
