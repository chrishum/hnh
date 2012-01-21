class CreatePerps < ActiveRecord::Migration
  def change
    create_table :perps do |t|
      t.string :first_name
      t.string :last_name
      t.integer :party_id
      t.timestamps
    end
    
    add_index :perps, :party_id
  end
end
