class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.string :content
      t.integer :perp_id
      t.date :date
      t.string :primary_source
      t.text :context
      t.text :description

      t.timestamps
    end
    add_index :statements, :perp_id
  end
end
