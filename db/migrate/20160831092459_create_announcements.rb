class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :url
      t.string :message
      t.string :date
      t.timestamps null: false
    end
  end
end
