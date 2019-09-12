class AddSectionToMedium < ActiveRecord::Migration
  def change
    add_reference :media, :section, index: true
    add_reference :darshans, :section, index: true
  end

end