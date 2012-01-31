require 'spec_helper'

describe Rating do

  before(:each) do
    @user = Factory(:user)
    @statement = Factory(:statement)
    @attr = { :rating => 56 }
  end
  
  it "should create a new hypocrisy rating given valid attributes" do
    @rating = @statement.hypocrisy_ratings.build(@attr)
    @rating.user = @user
    @rating.save!
  end
  
  describe "statement associations" do
    
    before(:each) do
      @rating = @statement.hypocrisy_ratings.create(@attr)
    end
    
    it "should have a statement attribute" do
      @rating.should respond_to(:statement)
    end
    
    it "should have the right associated statement" do
      @rating.statement_id.should == @statement.id
      @rating.statement.should == @statement
    end
  end
  
  describe "user associations" do

    before(:each) do
      @rating = @statement.hypocrisy_ratings.build(@attr)
      @rating.user = @user
      @rating.save!
    end

    it "should have a user attribute" do
      @rating.should respond_to(:user)
    end

    it "should have the right associated user" do
      @rating.user_id.should == @user.id
      @rating.user.should == @user
    end
  end
  
  describe "validations" do
    
    it "should reject duplicate hypocrisy ratings" do
      @rating = @statement.hypocrisy_ratings.build(@attr)
      @rating.user = @user
      @rating.save!
      
      @dup_rating = @statement.hypocrisy_ratings.build(@attr)
      @dup_rating.user = @user
      @dup_rating.should_not be_valid
    end
  end
end