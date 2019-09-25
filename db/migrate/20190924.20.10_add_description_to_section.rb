class AddDescriptionToSection < ActiveRecord::Migration
  def change
    add_column :sections, :description, :string
    add_reference :sections, :group, index: true
  end
end
