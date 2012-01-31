require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { 
      :handle => "Example User", 
      :email => "user@example.com", 
      :password => "foobar", 
      :password_confirmation => "foobar" 
      }
  end

  describe "validations" do
    
    it "should create a new instance given valid attributes" do
      User.create!(@attr)
    end

    it "should require a name" do
      no_name_user = User.new(@attr.merge(:handle => ""))
      no_name_user.should_not be_valid
    end

    it "should require an email address" do
      no_email_user = User.new(@attr.merge(:email => ""))
      no_email_user.should_not be_valid
    end

    it "should reject names that are too long" do
      long_name = "a" * 51
      long_name_user = User.new(@attr.merge(:handle => long_name))
      long_name_user.should_not be_valid
    end

    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should be_valid
      end
    end

    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end

    it "should reject duplicate email addresses" do
      # Put a user with given email address into the database.
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end

    it "should reject email addresses identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
  end
  
  describe "Password validations" do
  
    it "should require a password" do
      no_password_user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
      no_password_user.should_not be_valid
    end
  
    it "should require a matching password confirmation" do
      mismatch_password_user = User.new(@attr.merge(:password_confirmation => "invalid"))
      mismatch_password_user.should_not be_valid
    end
  
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:crypted_password)
    end
    
    it "should set the encrypted password" do
      @user.crypted_password.should_not be_blank
    end
  end
  
  describe "admin attribute" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  
  describe "ratings association" do
    
    before(:each) do
      @user = User.create!(@attr)
      @hypocrisy_ratings = [Factory(:hypocrisy_rating, :user => @user), Factory(:hypocrisy_rating, :user => @user)]
      @hyperbole_ratings = [Factory(:hyperbole_rating, :user => @user)]
    end

    it "should respond to hypocrisy_ratings" do
      @user.should respond_to(:hypocrisy_ratings)
    end
    
    it "should have the correct hypocrisy_ratings_count" do
      @user.reload.hypocrisy_ratings_count.should == @hypocrisy_ratings.count
    end
    
    it "should respond to hyperbole_ratings" do
      @user.should respond_to(:hyperbole_ratings)
    end
    
    it "should have the correct hyperbole_ratings_count" do
      @user.reload.hyperbole_ratings_count.should == @hyperbole_ratings.count
    end
  end    
end
# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  handle            :string(255)
#  email             :string(255)
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  perishable_token  :string(255)
#  admin             :boolean         default(FALSE)
#  created_at        :datetime
#  updated_at        :datetime
#

