class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :handle
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :perishable_token
      t.boolean :admin, :default => false
      t.timestamps
    end
    
    add_index :users, :email, :unique => true
  end
end
