class AddServiceToSadhnaCard < ActiveRecord::Migration
  def change
    add_column :sadhna_cards, :service, :string
  end
end
