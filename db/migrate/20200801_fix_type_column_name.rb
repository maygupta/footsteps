class FixTypeColumnName < ActiveRecord::Migration
  def self.up
    rename_column :questions, :type, :ask_type
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end