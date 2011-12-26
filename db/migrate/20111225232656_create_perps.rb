class CreatePerps < ActiveRecord::Migration
  def change
    create_table :perps do |t|
      t.string :first_name
      t.string :last_name
      t.string :party

      t.timestamps
    end
  end
end
