class AddStatementsCountToPerps < ActiveRecord::Migration
  def self.up
    change_table :perps do |t|
      t.integer :statements_count, :default => 0
    end
  end
  
  def self.down
    change_table :perps do |t|
      t.remove :statements_count
    end
  end
end
