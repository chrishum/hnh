class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :statement_id
      t.string  :type
      t.integer :rating
      t.timestamps
    end
    add_index :ratings, :user_id
    add_index :ratings, :statement_id
    add_index :ratings, [:user_id, :statement_id, :type], :unique => true
    add_index :ratings, [:user_id, :type]
    add_index :ratings, [:statement_id, :type]
  end
end
