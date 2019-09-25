class AddDescriptionToSection < ActiveRecord::Migration
  def change
    add_column :section, :description, :string
    add_reference :section, :group, index: true
  end
end
