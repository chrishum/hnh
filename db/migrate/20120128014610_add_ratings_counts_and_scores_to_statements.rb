class AddRatingsCountsAndScoresToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :hypocrisy_score, :integer, :default => nil
    add_column :statements, :hyperbole_score, :integer, :default => nil
    add_column :statements, :score, :integer, :default => nil
    add_column :statements, :hypocrisy_ratings_count, :integer, :default => 0
    add_column :statements, :hyperbole_ratings_count, :integer, :default => 0
    add_index  :statements, :score
    add_index  :statements, :hypocrisy_score
    add_index  :statements, :hyperbole_score
  end
end
