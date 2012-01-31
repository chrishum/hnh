require 'spec_helper'

describe Rating do

  before(:each) do
    @user = Factory(:user)
    @statement = Factory(:statement)
    @attr = { :rating => 56, 
              :type   => "HyperboleRating"
              }
  end
  
  describe "validations" do
    
    before(:each) do
      @rating = Rating.new(@attr)
      @rating.statement_id = @statement.id
      @rating.user_id = @user.id
    end
    
    it "should require a rating" do
      @rating.rating = ""
      @rating.should_not be_valid
    end
    
    it "should reject non-integer ratings" do
      @rating.rating = 10.5
      @rating.should_not be_valid
    end
    
    it "should reject low ratings" do
      @rating.rating = -1
      @rating.should_not be_valid
    end
    
    it "should reject high ratings" do
      @rating.rating = 101
      @rating.should_not be_valid
    end
    
    it "should require a statement" do
      @rating.statement_id = ""
      @rating.should_not be_valid
    end
    
    it "should require a user" do
      @rating.user_id = ""
      @rating.should_not be_valid
    end
  end
end