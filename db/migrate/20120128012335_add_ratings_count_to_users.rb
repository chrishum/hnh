class AddRatingsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hypocrisy_ratings_count, :integer, :default => 0
    add_column :users, :hyperbole_ratings_count, :integer, :default => 0
  end
end
