class ChangePerpPartyToPartyId < ActiveRecord::Migration
  def up
    change_table :perps do |t|
      t.remove :party
      t.references :party
      t.index :party_id
    end
  end

  def down
    change_table :perps do |t|
      t.remove_index :party_id
      t.remove :party_id
      t.string :party
    end
  end
end
