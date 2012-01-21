class CreateOffices < ActiveRecord::Migration
  def change
    create_table :offices do |t|
      t.string :title
      t.string :state
      t.integer :party_id
      t.date :start_date
      t.date :end_date
      t.integer :perp_id

      t.timestamps
    end
  end
end
