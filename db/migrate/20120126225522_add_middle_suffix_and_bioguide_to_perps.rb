class AddMiddleSuffixAndBioguideToPerps < ActiveRecord::Migration
  def self.up
    change_table :perps do |t|
      t.string :middle_name, :default => ""
      t.string :name_suffix, :default => ""
      t.string :bioguide_id
    end 
  end
  
  def self.down
    change_table :perps do |t|
      t.remove :bioguide_id
      t.remove :name_suffix
      t.remove :middle_name
    end
  end
end
