class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.string :three_letter
      t.string :one_letter

      t.timestamps
    end
    
    add_index :parties, :name, :unique => true
  end
end
