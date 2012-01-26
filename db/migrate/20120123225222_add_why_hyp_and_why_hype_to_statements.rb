class AddWhyHypAndWhyHypeToStatements < ActiveRecord::Migration
  def self.up
    change_table :statements do |t|
      t.rename :description, :why_hypocritical
      t.text   :why_hyperbolical
    end
  end
  
  def self.down
    change_table :statements do |t|
      t.remove :why_hyperbolical
      t.rename :why_hypocritical, :description
    end
  end
end
