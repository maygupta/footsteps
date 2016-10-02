class CreateBhaktiSangaDevotees < ActiveRecord::Migration
  def change
    create_table :bhakti_sanga_devotees do |t|
      t.integer :devotee_id
      t.integer :bhakti_sanga_id

      t.timestamps
    end
  end
end
