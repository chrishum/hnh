class AddPartyNameUniquenessIndex < ActiveRecord::Migration
  def up
    add_index :parties, :name, :unique => true
  end

  def down
    remove_index :parties, :name
  end
end
