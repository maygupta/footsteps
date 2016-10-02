class CreateBhaktiSanga < ActiveRecord::Migration
  def change
    create_table :bhakti_sangas do |t|
      t.date :on
      t.string :lecture_by
      t.string :topic

      t.timestamps null: false
    end
  end
end
